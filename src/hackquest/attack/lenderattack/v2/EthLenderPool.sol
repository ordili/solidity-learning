// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "solmate/utils/SafeTransferLib.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

contract EthLenderPool {
    mapping(address => uint256) public balances;

    error RepayFailed();

    event Deposit(address indexed who, uint256 amount);
    event Withdraw(address indexed who, uint256 amount);

    function deposit() external payable {
        unchecked {
            balances[msg.sender] += msg.value;
        }
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        delete balances[msg.sender];
        emit Withdraw(msg.sender, amount);
        SafeTransferLib.safeTransferETH(msg.sender, amount);
    }

    /**
     * 风险点：只判断了还款后 EthLenderPool 合约余额的大小，但这个余额可能包含用户存在合约中的资产，
     * 对于这部分资产，用户是可以随时提走的。如下是攻击者合约，这里使用了 attack 函数发起闪电贷，
     * 并顺利提走了资金，它是怎么做到的？在回调函数 execute 中，攻击者将闪电贷借来的资金又存到了资金池中，
     * 从而保证资金池中的资金并没有减少，但现在资金却被记录成了攻击者的！
     */
    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();
        if (address(this).balance < balanceBefore) {
            revert RepayFailed();
        }
    }
}
