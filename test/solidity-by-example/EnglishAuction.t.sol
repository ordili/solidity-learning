// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "solidity-by-example/EnglishAuction.sol";

contract EnglishAuctionTest is Test {
    EnglishAuction public englishAuction;
    address payable public sender;

    function setUp() public {
        initSender();
        vm.prank(sender);
        englishAuction = new EnglishAuction(180);
    }

    function initSender() internal {
        sender = payable(makeAddr("testSender"));
        uint256 amount = 1000 wei;
        vm.deal(sender, amount);
        assertEq(amount, sender.balance);
        // vm.prank(sender);
    }

    function testBid() public {
        uint256 amount = 100 wei;
        vm.prank(sender);
        console.log("sender balance is ", sender.balance);
        console.log("contract balance is ", address(englishAuction).balance);
        englishAuction.bid{value: amount}();
        assertEq(address(englishAuction).balance, amount);
        assertEq(englishAuction.currentPrice(), amount);
        assertEq(englishAuction.currentBidder(), sender);

        address anotherSender = payable(makeAddr("testSender"));
        vm.deal(anotherSender, 1 ether);
        amount = 200 wei;
        vm.prank(anotherSender);

        englishAuction.bid{value: amount}();

        assertEq(address(englishAuction).balance, amount);
        assertEq(englishAuction.currentPrice(), amount);
        assertEq(englishAuction.currentBidder(), anotherSender);
    }

    function testWithdraw() public {
        uint256 amount = 100 wei;
        vm.prank(sender);
        console.log("sender balance is ", sender.balance);
        console.log("contract balance is ", address(englishAuction).balance);
        englishAuction.bid{value: amount}();

        assertEq(address(englishAuction).balance, amount);

        uint256 currentTime = block.timestamp;
        uint256 futureTime = currentTime + englishAuction.remainTime() + 1;

        vm.warp(futureTime);

        vm.prank(sender);
        englishAuction.withdraw();

        assertEq(address(englishAuction).balance, 0);
    }
}
