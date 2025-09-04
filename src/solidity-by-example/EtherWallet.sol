// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * An example of a basic wallet.
 *   Anyone can send ETH.
 *   Only the owner can withdraw.
 */
contract EtherWallet {
    event Received(address indexed from, uint256 amount);
    event Withdraw(address indexed from, uint256 amount);

    address payable public immutable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw.");
        uint256 balance = address(this).balance;
        owner.transfer(balance);
        emit Withdraw(msg.sender, balance);
    }
}
