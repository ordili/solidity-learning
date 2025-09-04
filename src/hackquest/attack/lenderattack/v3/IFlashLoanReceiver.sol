// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IFlashLoanReceiver {
    function executeOperation(uint256 amounts, address receiverAddress, address _initiator, bytes calldata data)
        external;
}
