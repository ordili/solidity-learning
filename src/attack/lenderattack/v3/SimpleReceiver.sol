// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./LendingPool.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract SimpleReceiver is IFlashLoanReceiver {
    using SafeERC20 for IERC20;

    IERC20 public myToken;
    LendingPool public lendingPool;

    constructor(address _lendingPoolAddress, address _asset) {
        lendingPool = LendingPool(_lendingPoolAddress);
        myToken = IERC20(_asset);
    }

    function flashLoan(uint256 amounts, address receiverAddress, bytes calldata data) external {
        receiverAddress = address(this);
        lendingPool.flashLoan(amounts, receiverAddress, data);
    }

    function executeOperation(uint256 amounts, address receiverAddress, address _initiator, bytes calldata data)
        external
    {
        // the business logic ...

        // transfer all borrowed assets back to the lending pool
        IERC20(myToken).safeTransfer(address(lendingPool), amounts);
    }
}
