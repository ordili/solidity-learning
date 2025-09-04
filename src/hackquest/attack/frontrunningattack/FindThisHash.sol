// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * 这是一个猜谜游戏，如果您能找到目标哈希对应的正确字符串，您将赢得 10 个以太币。
 * @title
 * @author gidong
 * @dev
 */
contract FindThisHash {
    bytes32 public constant hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    constructor() payable {}

    /// @notice 会受到Front Running 攻击；
    /// @param solution solution
    function solve(string memory solution) public {
        require(hash == keccak256(abi.encodePacked(solution)), "Incorrect answer");
        (bool sent,) = msg.sender.call{value: 10 ether}("");
        require(sent, "Failed to send Ether");
    }
}
