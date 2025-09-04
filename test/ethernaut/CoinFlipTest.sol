// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";
import "ethernaut/CoinFlip.sol";

contract CoinFlipTest is Test {
    CoinFlip public coinFlip;
    CoinFlipAttack public attacker;

    constructor() {
        coinFlip = new CoinFlip();
        attacker = new CoinFlipAttack(address(coinFlip));
    }

    function testAttack() public {
        assertEq(0, coinFlip.consecutiveWins());
        uint256 count = coinFlip.consecutiveWins();

        uint256 startBlock = block.number;
        vm.roll(startBlock + 1);
        attacker.attack();
        count += 1;
        assertEq(count, coinFlip.consecutiveWins());

        startBlock = block.number;
        vm.roll(startBlock + 1);
        attacker.attack();
        count += 1;
        assertEq(count, coinFlip.consecutiveWins());

        startBlock = block.number;
        vm.roll(startBlock + 1);
        attacker.attack();
        count += 1;
        assertEq(count, coinFlip.consecutiveWins());
    }
}
