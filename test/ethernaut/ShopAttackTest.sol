// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Shop} from "ethernaut/Shop.sol";
import {ShopAttack} from "ethernaut/ShopAttack.sol";
import {Test} from "forge-std/Test.sol";

contract ShopAttackTest is Test {
    Shop public shop;
    ShopAttack public shopAttack;

    function setUp() public {
        shop = new Shop();
        shopAttack = new ShopAttack(address(shop));
    }

    function test_attack() public {
        assertEq(shop.isSold(), false);
        assertEq(shop.price(), 100);

        shopAttack.attack();

        assertEq(shop.isSold(), true);
        assertEq(shop.price(), 1);
    }
}
