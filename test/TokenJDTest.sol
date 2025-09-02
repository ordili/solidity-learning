// SPDX-License-Identifier: MIK
pragma solidity ^0.8.10;

import "../src/TokenJD.sol";
import {Test} from "forge-std/Test.sol";
import {Token} from "../src/vulnerable/Token.sol";

contract TokenJDTest is Test {
    TokenJD public tokenJD;

    constructor() {
        tokenJD = new TokenJD();
    }

    function testTransfer() public {
        address other = makeAddr("other");
        tokenJD.transfer(other, 10 wei);
        assertEq(10 wei, tokenJD.balanceOf(other));
    }
}
