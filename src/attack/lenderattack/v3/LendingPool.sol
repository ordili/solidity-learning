// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./IFlashLoanReceiver.sol";

contract LendingPool {
    IERC20 public myToken;

    constructor(address _myToken) {
        myToken = IERC20(_myToken);
    }

    function flashLoan(uint256 amount, address borrower, bytes calldata data) public {
        // step 1: check
        uint256 balanceBefore = myToken.balanceOf(address(this));
        require(balanceBefore >= amount, "Not enough liquidity");

        // step 2: transfer
        require(myToken.transfer(borrower, amount), "Flashloan transfer failed");

        // step 3: callback
        IFlashLoanReceiver(borrower).executeOperation(amount, borrower, msg.sender, data);

        // step 4: recheck
        uint256 balanceAfter = myToken.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Flashloan not repaid");
    }
}
