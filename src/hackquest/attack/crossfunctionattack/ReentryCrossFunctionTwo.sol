// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 *  跨函数重入攻击
 *  跨函数重入攻击是更复杂的一种重入攻击方式，通常出现此问题的原因是多个函数相互共享同一状态变量，
 * 并且其中一些函数不安全地更新该变量。这种漏洞允许攻击者在一个函数执行期间通过另一个函数重新进入合约，
 * 操作尚未更新的状态数据。
 */
contract ReentryCrossFunctionTwo {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] = msg.value;
    }

    function transfer(address to, uint256 amount) public {
        if (balances[msg.sender] >= amount) {
            balances[to] += amount;
            balances[msg.sender] -= amount;
        }
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
        balances[msg.sender] = 0;
    }
}
