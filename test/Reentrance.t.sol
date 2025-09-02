// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test, console, Vm} from "forge-std/Test.sol";
import {Reentrance} from "../src/vulnerable/Reentrance.sol";
import {ReentranceAttack} from "../src/attack/ReentranceAttack.sol";

contract ReentranceTest is Test {
    Reentrance public reentrance;
    ReentranceAttack public reentranceAttack;

    function setUp() public {
        reentrance = new Reentrance();
        reentranceAttack = new ReentranceAttack(address(reentrance));
    }

    function test_attack() public {
        vm.recordLogs();

        reentrance.donate{value: 10 wei}(msg.sender);

        address sender = makeAddr("user");

        vm.deal(sender, 100 wei);

        vm.startPrank(sender);

        reentrance.donate{value: 2 wei}(sender);

        uint256 reentranceAttackBalanceBf = address(reentranceAttack).balance;
        console.log("reentranceAttackBalanceBf is ", reentranceAttackBalanceBf);
        uint256 bfAttackContractBalance = address(reentrance).balance;
        console.log("bfAttackContractBalance is ", bfAttackContractBalance);
        reentranceAttack.attack{value: 2 wei}();
        console.log("attack withdraw 2 wei");
        uint256 afterAttackContractBalance = address(reentrance).balance;
        uint256 reentranceAttackBalanceAf = address(reentranceAttack).balance;
        console.log("afterAttackContractBalance is ", afterAttackContractBalance);
        console.log("reentranceAttackBalanceAf is ", reentranceAttackBalanceAf);

        // 获取记录的所有日志
        Vm.Log[] memory logs = vm.getRecordedLogs();

        // 输出事件数量
        console.log("Number of events emitted:", logs.length);

        // 解析并输出每个事件
        for (uint256 i = 0; i < logs.length; i++) {
            console.log("=== Event", i, "===");
            console.log("Emitter address:", logs[i].emitter);
            console.log("Topics count:", logs[i].topics.length);
            console.log("Data length:", logs[i].data.length);

            // 检查是否是 Transfer 事件
            bytes32 attackReceivedSig = keccak256("AttackReceived(address,uint256)");
            if (logs[i].topics[0] == attackReceivedSig) {
                console.log("Event type: Transfer");
                (address from, address to, uint256 value) = abi.decode(logs[i].data, (address, address, uint256));
                console.log("From:", from);
                console.log("To:", to);
                console.log("Value:", value);
            }
            vm.stopPrank();
        }
    }

    function test_donate() public {
        address addr = msg.sender; //address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        uint256 amount = 1 ether;
        uint256 bfBalance = reentrance.balanceOf(addr);
        reentrance.donate{value: amount}(addr);
        uint256 afBalance = reentrance.balanceOf(addr);
        assertEq(bfBalance + amount, afBalance);
    }

    function xx_test_withdraw() public {
        console.log("msg.sender is :", msg.sender);
        address addr = makeAddr("user");
        // ！！！核心步骤：给这个用户钱包地址充值 100 wei
        vm.deal(addr, 100 wei);
        // 开始模拟 alice
        vm.startPrank(addr);
        console.log("user balance is : ", addr.balance);
        uint256 amount = 2 wei;
        console.log("before donate 2 wei user balance is : ", addr.balance);
        reentrance.donate{value: amount}(addr);
        console.log("after  donate 2 wei user balance is : ", addr.balance);
        console.log("bf withdraw 2 wei balance : ", addr.balance);
        uint256 bfBalance = addr.balance;
        reentrance.withdraw(amount);
        console.log("af withdraw 2wei balance : ", addr.balance);
        uint256 afBalance = addr.balance;

        console.log("msg.sender is :", msg.sender);
        vm.stopPrank();
        assertEq(bfBalance + amount, afBalance);
    }
}
