// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract TokenB {
    using ECDSA for bytes32;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 TokenB";
    string public symbol = "SETB";
    uint8 public decimals = 18;
    mapping(address => uint256) nonces;

    // ... 其他函数跟 TokenA 一样
}