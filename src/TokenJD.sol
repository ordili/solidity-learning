// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TokenJD is ERC20("TokenJD", "JD") {
    constructor() {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}
