// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";
import "forge-std/console2.sol";

import {Counter} from "../src/vulnerable/Counter.sol";

contract CodeHashTest is Test {
    Counter public counter;

    constructor() {
        counter = new Counter();
    }

    /**
     * The output of addr.codehash may be 0 if the account associated with addr is empty or non-existent
     *
     * If the account has no code but a non-zero balance or nonce,
     * then addr.codehash will output the Keccak-256 hash of empty data (i.e., keccak256("")
     * which is equal to c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470),
     * as defined by EIP-1052.
     */
    function testEOAAddress() public {
        address addrWithBalance = makeAddr("Abc");
        address emptyAddress = address(1);
        vm.deal(addrWithBalance, 10 ether);

        //0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
        assertEq(keccak256(""), addrWithBalance.codehash);
        assertEq(0, uint256(emptyAddress.codehash));

        console2.logBytes32(addrWithBalance.codehash);
        console2.logBytes32(emptyAddress.codehash);
    }
}
