// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../src/learning/MappingStorage.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract MappingStorageTest is Test {
    MappingStorage public mappingStorage;

    constructor() {}

    function setUp() public {
        mappingStorage = new MappingStorage();
    }

    function testAddBalanceBySlot() public {
        address key = makeAddr("Test");
        mappingStorage.addBalanceBySlot(key, 100 ether);
        assertEq(100 ether, mappingStorage.getBalancesBySlot(key));
        assertEq(100 ether, mappingStorage.balances(key));
    }
}
