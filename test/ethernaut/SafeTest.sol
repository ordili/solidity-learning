// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";
import {Safe} from "../../src/Safe.sol";

interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);

    function transfer(address, uint256) external returns (bool);

    function decimals() external returns (uint8);
}

contract SafeTest is Test {
    Safe safe;

    constructor() {}

    function setUp() public {
        safe = new Safe();
    }

    function test_Withdraw() public {
        //        uint256 preBalance = address(this).balance;
        //        payable(address(safe)).transfer(1 ether);
        //        safe.withdraw();
        //        uint256 postBalance = address(this).balance;
        //        assertEq(preBalance - 1 ether, postBalance);
    }
}
