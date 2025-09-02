// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 * 我们在这里介绍一个简单的小游戏：KingOfEther，该合约允许任何地址通过支付更多的 ETH
 * 来夺取 king 的头衔。当新的 king 产生时，合约会尝试将之前 king 的 balance
 * 资金退还给他。
 *
 * 漏洞分析：
 * 这里通过 call 低代码调用的方式发送 ETH，如果 king 是个普通的 EOA 账户，
 * 是没有问题的。但 king 如果是一个恶意合约，比如它没有可接收 ETH 的 fallback 函数，
 * 或者 fallback 默认失败，那么资金退还过程必然失败。该合约也无法再接受其他地址的挑战，
 * 即 Denial of Service。
 */
contract KingOfEther {
    address public king;
    uint256 public balance;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");

        (bool sent,) = king.call{value: balance}("");
        require(sent, "Failed to send Ether");

        balance = msg.value;
        king = msg.sender;
    }
}
