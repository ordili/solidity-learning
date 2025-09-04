// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/utils/Address.sol";
import "./MyToken.sol";
import "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract LenderPool is ReentrancyGuard {
    using Address for address;

    MyToken public token;

    error RepayFailed();

    constructor(MyToken _token) {
        token = _token;
    }

    function flashLoan(uint256 amount, address borrower, address target, bytes calldata data)
        external
        nonReentrant
        returns (bool)
    {
        uint256 balanceBefore = token.balanceOf(address(this));
        token.transfer(borrower, amount);

        // it's dangerous
        target.functionCall(data);

        if (token.balanceOf(address(this)) < balanceBefore) {
            revert RepayFailed();
        }

        return true;
    }
}
