// SPDX-License-Identifier: MIK
pragma solidity ^0.8.10;

contract DirectStorageAccess {
    uint256 public a;
    uint256 public b;

    constructor() {}

    function setA(uint256 _a) external {
        a = _a;
    }

    function setB(uint256 _b) external {
        b = _b;
    }

    function readSlot(uint256 slot) public view returns (bytes32 result) {
        assembly {
            result := sload(slot)
        }
    }

    function readUint256(uint256 slot) public view returns (uint256 result) {
        assembly {
            result := sload(slot)
        }
    }

    function writeUint256(uint256 slot, uint256 newValue) public {
        assembly {
            sstore(slot, newValue)
        }
    }

    function writeSlot(uint256 slot, bytes32 newValue) public {
        assembly {
            sstore(slot, newValue)
        }
    }

    function getSlot() public pure returns (bytes32) {
        return keccak256("secret.storage.slot");
    }
}
