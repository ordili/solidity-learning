// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";

contract DemoTest is Test {
    function testXX() public pure {
        address account = 0xC2929457BDb86Bca5759ABBB64D0e6264367aF6a;
        bytes memory sig = abi.encodeWithSignature("balanceOf(address)", account);
        console.logBytes(sig);
    }
}
