// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./StorageUtils.sol";

contract MappingStorage {
    uint256 public value; // slot 0
    mapping(address => uint256) public balances; // slot 1

    constructor() {}

    function getBalanceSlot(address _addr) public pure returns (bytes32) {
        // keccak256(abi.encode(_addr, slot))
        uint256 slot = 1;
        return keccak256(abi.encode(_addr, slot));
    }

    function addBalance(address addr, uint256 amount) external {
        balances[addr] = amount;
    }

    function getBalancesBySlot(address key) external view returns (uint256) {
        return StorageUtils.readUint256(getBalanceSlot(key));
    }

    function addBalanceBySlot(address addr, uint256 amount) external {
        StorageUtils.writeUint256(getBalanceSlot(addr), amount);
    }
}
