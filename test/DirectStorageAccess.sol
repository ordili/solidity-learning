// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../src/learning/DirectStorageAccess.sol";
import {Test, console} from "../lib/forge-std/src/Test.sol";

contract DirectStorageAccessTest is Test {
    DirectStorageAccess public directStorageAccess;

    constructor() {
        directStorageAccess = new DirectStorageAccess();
    }

    function testReadUint256() public {
        uint256 slot = 1;
        uint256 newValue = 100;
        directStorageAccess.writeUint256(slot, newValue);
        uint256 ret = directStorageAccess.readUint256(slot);
        assertEq(ret, newValue);
    }

    function testGetSlot() public {
        directStorageAccess.setA(1);
        directStorageAccess.setB(2);
        bytes32 a = directStorageAccess.readSlot(0);
        bytes32 b = directStorageAccess.readSlot(1);
        uint256 aInt = uint256(a);
        uint256 bInt = uint256(b);
        assertEq(aInt, 1);
        assertEq(bInt, 2);
    }

    function testSetSlot() public {
        bytes32 a = bytes32(uint256(2));
        bytes32 b = bytes32(uint256(3));
        directStorageAccess.writeSlot(0, a);
        directStorageAccess.writeSlot(1, b);
        uint256 aInt = directStorageAccess.a();
        uint256 bInt = directStorageAccess.b();
        assertEq(aInt, 2);
        assertEq(bInt, 3);
    }

    function testGetSlotNo() public view {
        bytes32 ret = directStorageAccess.getSlot();
        console.log("slot is ", uint256(ret));
    }
}
