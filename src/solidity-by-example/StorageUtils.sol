// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library StorageUtils {
    function readUint256(bytes32 slot) internal view returns (uint256 value) {
        assembly {
            value := sload(slot)
        }
    }

    function writeUint256(bytes32 slot, uint256 value) internal {
        assembly {
            sstore(slot, value)
        }
    }
}
