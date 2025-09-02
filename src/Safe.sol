// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Safe {
    constructor() {}
    receive() external payable {}

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
