// SPDX-License-Identifier: MIK
pragma solidity ^0.8.13;

import "solidity-by-example/hacks/SelfDestructAttack.sol";
import {Test, console} from "forge-std/Test.sol";

contract SelfDestructAttackTest is Test {
    EtherGame public etherGame;
    Attack public attack;
    address public sender;

    function setUp() public {
        initSender();
        etherGame = new EtherGame();
        attack = new Attack(address(etherGame));
    }

    function initSender() internal {
        sender = payable(makeAddr("testSender"));
        uint256 amount = 1000 wei;
        vm.deal(sender, amount);
        assertEq(amount, sender.balance);
        // vm.prank(sender);
    }

    function testPlayGame() public {
        vm.startPrank(sender);

        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        assertEq(2 wei, address(etherGame).balance);
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.reclaimGameBonus();

        vm.stopPrank();
    }

    function testAttack() public {
        vm.startPrank(sender);
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();
        etherGame.playGame{value: 1 wei}();

        assertEq(4, address(etherGame).balance);

        attack.attack{value: 8 wei}();

        assertTrue(address(etherGame).balance > etherGame.TARGET_AMOUNT(), "attack failed.");

        vm.stopPrank();
    }
}
