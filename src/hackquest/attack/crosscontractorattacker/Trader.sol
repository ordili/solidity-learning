// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./Bank.sol";

contract Trader {
    Bank bank;

    constructor(address _bank) {
        bank = Bank(_bank);
    }

    /**
     * 在这个场景中，如果 Trader 合约中的 exploitWithdrawal 方法能够在 Bank
     * 合约的 withdraw方法的外部调用完成前被重入，那么可能会在Bank合约的状态更新
     * （即balances[to] -= amount）之前多次提取资金
     */
    function exploitWithdrawal(address to) public {
        bank.withdraw(to, 100);
    }
}
