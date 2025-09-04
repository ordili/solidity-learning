// SPDX-License-Identifier: MIK
pragma solidity ^0.8.10;

import "../src/TokenJD.sol";
import {Test} from "forge-std/Test.sol";
import {Token} from "ethernaut/Token.sol";

contract TokenJDTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);

    TokenJD public tokenJD;
    address public sender;

    constructor() {
        sender = makeAddr("user");
        vm.deal(sender, 10 ether);
        vm.prank(sender);
        tokenJD = new TokenJD();
    }

    function testTransferEvent() public {
        address other = makeAddr("other");
        // 期望下一个emit的事件是 Transfer，并且参数分别是 address(this), alice, 100
        vm.expectEmit(true, true, true, true);
        // 定义期望的事件：必须是完全相同的签名和参数
        emit Transfer(sender, other, 10);
        vm.prank(sender);
        tokenJD.transfer(other, 10 wei);
        assertEq(10 wei, tokenJD.balanceOf(other));
    }
}
