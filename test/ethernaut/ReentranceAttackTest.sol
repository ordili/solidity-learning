// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";

import "ethernaut/ReentranceAttack.sol";

contract ReentranceAttackTest is Test {
    Reentrance public reentrance;
    ReentranceAttack public reentranceAttack;

    constructor() {
        reentrance = new Reentrance();
        reentranceAttack = new ReentranceAttack(address(reentrance));
    }

    function testAttack() public {
        address addr1 = address(1);
        address addr2 = address(2);

        reentrance.donate{value: 5 wei}(addr1);
        reentrance.donate{value: 10 wei}(addr2);

        assertEq(15, address(reentrance).balance);

        reentranceAttack.attack{value: 100}();

        assertEq(0, address(reentrance).balance);
        assertEq(115, address(reentranceAttack).balance);
    }
}
