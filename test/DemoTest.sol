// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";

contract DemoTest is Test {
    function testXX() public pure {
        console.log("max is :", type(uint).max);
        console.log("min is :", type(uint).min);
    }
}
