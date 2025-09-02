// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";

contract TimeTest is Test {
    // vm.warp - set block.timestamp to future timestamp
    // vm.roll - set block.number
    // skip - increment current timestamp
    // rewind - decrement current timestamp

    function test() public {
        console.log("timestamp", block.timestamp);
        console.log("block number", block.number);

        console.log("warp 10");
        vm.warp(block.timestamp + 10);
        console.log("timestamp", block.timestamp);

        console.log("skip 10");
        skip(10);
        console.log("timestamp", block.timestamp);

        console.log("roll 10");
        vm.roll(10);
        console.log("block number", block.number);

        console.log("rewind 10");
        rewind(10);
        console.log("timestamp", block.timestamp);
    }
}
