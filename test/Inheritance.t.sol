// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../src/learning/Inheritance.sol";
import {Test, console} from "forge-std/Test.sol";

contract InheritanceTest is Test {
    L3ChildAB public l3ChildAB;
    L3ChildBA public l3ChildBA;
    L3ChildBA2 public l3ChildBA2;

    constructor() {}

    function setUp() public {
        l3ChildAB = new L3ChildAB();
        l3ChildBA = new L3ChildBA();
        l3ChildBA2 = new L3ChildBA2();
    }

    function testL3ChildAB() public view {
        assertEq("L2ChildB-Foo", l3ChildAB.foo());
        assertEq("L2ChildA-Foo", l3ChildBA.foo());
        assertEq("L2ChildA-Foo", l3ChildBA2.foo());
    }
}
