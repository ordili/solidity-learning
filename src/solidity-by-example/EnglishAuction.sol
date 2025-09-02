// SPDX-License-Identifier: MIK
pragma solidity ^0.8.10;

contract EnglishAuction {
    event Start();
    event End();
    event Withdraw(address indexed bidder, uint256 amount);
    event Bid(address indexed sender, uint256 amount);

    address public currentBidder;
    address public owner;
    uint256 public startTime;
    uint256 public endTime;

    constructor(uint256 _endTime) {
        startTime = block.timestamp;
        endTime = startTime + _endTime;
        owner = msg.sender;
        currentBidder = address(0);
    }

    function bid() external payable {
        require(block.timestamp >= startTime, "not started.");
        require(block.timestamp < endTime, "auction ended.");
        require(msg.value > address(this).balance, "auction price is too low.");
        currentBidder = msg.sender;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw.");
        require(block.timestamp >= endTime, "auctions is not end.");
        payable(msg.sender).transfer(address(this).balance);
    }

    function isEnd() external view returns (bool) {
        return endTime < block.timestamp;
    }

    function remainTime() external view returns (uint256) {
        require(!this.isEnd(), "Has ended.");
        return endTime - block.timestamp;
    }
}
