// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/learning/Proxy.sol";

contract ProxyTest is Test {
    LogicContract public logicContract;
    ProxyContract public proxyContract;
    address payable public sender;

    function setUp() public {
        logicContract = new LogicContract();
        proxyContract = new ProxyContract(address(logicContract));
        initSender();
    }

    function initSender() internal {
        sender = payable(makeAddr("testSender"));
        vm.deal(sender, 1 ether);
        assertEq(1 ether, sender.balance);
        // vm.prank(sender);
    }

    function testDirectCall() public {
        vm.prank(sender);

        uint256 newNumb = 100;
        uint256 amount = 20;
        proxyContract.directCall{value: amount}(newNumb);

        // logic context has been changed.
        assertEq(address(logicContract).balance, amount);
        assertEq(logicContract.num(), newNumb);
        assertEq(logicContract.value(), amount);
        // assertEq(logicContract.sender(), sender);

        // proxy context has not been changed.
        assertEq(address(proxyContract).balance, 0);
        assertEq(proxyContract.num(), 0);
        assertEq(proxyContract.value(), 0);
    }

    function testDelegateCall() public {
        vm.prank(sender);

        uint256 newNumb = 1000;
        proxyContract.delegateCall(newNumb);

        // logic context has not been changed.
        assertEq(address(logicContract).balance, 0);
        assertEq(logicContract.num(), 0);
        assertEq(logicContract.value(), 0);
        // assertEq(logicContract.sender(), sender);

        // proxy context has been changed.
        assertEq(address(proxyContract).balance, 0);
        assertEq(proxyContract.num(), newNumb);
        assertEq(proxyContract.value(), 0);
    }
}
