// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/learning/Payable.sol";

contract PayableTest is Test {
    Payable public payableContract;
    address payable public sender;

    function setUp() public {
        vm.deal(sender, 100 wei);
        assertEq(100, sender.balance);
        vm.prank(sender);
        payableContract = new Payable{value: 1 wei}();
        assertEq(99, sender.balance);
        sender = payable(makeAddr("testSender"));
    }

    function test_deposit() public {
        uint256 bfBalance = address(payableContract).balance;
        payableContract.deposit{value: 1 wei}();
        assertEq(bfBalance + 1, address(payableContract).balance);
    }

    function test_withdraw() public {
        assertEq(1, address(payableContract).balance);
        vm.prank(sender);
        payableContract.withdraw();
        assertEq(0, address(payableContract).balance);
    }
}
