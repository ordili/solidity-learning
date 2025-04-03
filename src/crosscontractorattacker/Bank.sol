// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Bank {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(address to, uint amount) public {
        require(balances[to] >= amount, "Insufficient funds");
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
        balances[to] -= amount;
    }
}