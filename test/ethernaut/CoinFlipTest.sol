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

        attacker.attack();
        assertEq(0, coinFlip.consecutiveWins());
        attacker.attack();
        assertEq(1, coinFlip.consecutiveWins());
        attacker.attack();
        assertEq(2, coinFlip.consecutiveWins());
    }
}
