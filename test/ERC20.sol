// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test} from "../lib/forge-std/src/Test.sol";
import "../src/learning/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;

    function setUp() public {
        erc20 = new ERC20("JIDONG", "JD", 1);
    }

    function createAccount(string memory name) internal returns (address payable) {
        address payable sender = payable(makeAddr(name));
        vm.deal(sender, 1 ether);
        assertEq(1 ether, sender.balance);
        // vm.prank(sender);
        return sender;
    }

    function testMint() public {
        address payable addr1 = createAccount("Account1");
        address payable addr2 = createAccount("Account2");
        address payable addr3 = createAccount("Account3");

        erc20.mint(addr1, 1);
        erc20.mint(addr2, 2);
        erc20.mint(addr3, 3);

        assertEq(6, erc20.totalSupply());
        assertEq(1, erc20.balanceOf(addr1));
        assertEq(2, erc20.balanceOf(addr2));
        assertEq(3, erc20.balanceOf(addr3));
    }

    function testTransfer() public {
        address payable sender = createAccount("sender");
        address payable addr1 = createAccount("Account1");
        erc20.mint(sender, 100);
        vm.prank(sender);
        erc20.transfer(addr1, 40);
        assertEq(40, erc20.balanceOf(addr1));
        assertEq(60, erc20.balanceOf(sender));
    }

    function testApprove() public {
        address payable sender = createAccount("sender");
        address payable addr1 = createAccount("Account1");

        erc20.mint(sender, 100);

        vm.prank(sender);
        erc20.approve(addr1, 20);

        assertEq(20, erc20.allowance(sender, addr1));
    }

    function testTransferFrom() public {
        address payable sender = createAccount("sender");
        address payable spender = createAccount("Account1");
        address payable addr2 = createAccount("Account2");

        erc20.mint(sender, 100);

        assertEq(100, erc20.balanceOf(sender));

        vm.prank(sender);
        erc20.approve(spender, 20);

        assertEq(20, erc20.allowance(sender, spender));

        vm.prank(spender);
        erc20.transferFrom(sender, addr2, 18);

        assertEq(82, erc20.balanceOf(sender));
        assertEq(18, erc20.balanceOf(addr2));
    }

    function testBurn() public {
        address payable addr = createAccount("addr");
        erc20.mint(addr, 100);

        assertEq(100, erc20.balanceOf(addr));
        assertEq(100, erc20.totalSupply());

        erc20.burn(addr, 20);

        assertEq(80, erc20.balanceOf(addr));
        assertEq(80, erc20.totalSupply());
    }
}
