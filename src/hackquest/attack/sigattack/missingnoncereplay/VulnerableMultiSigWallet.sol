// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

/**
 * 签名重放攻击主要有以下几种常见类型:
 *  1.普通重放(Missing Nonce Replay)：重复使用同一份签名多次执行操作。
 *  2.跨链重放(Cross Chain Replay)：将同一份签名在不同的链上执行操作。
 *  3.参数缺失(Missing Parameter)：签名未包含操作所需的全部参数。
 *  4.无到期时间(No Expiration)：签名缺少有效期，可永久重放使用。
 * @title 存在普通重放签名攻击
 * @author
 * @dev
 */
contract VulnerableMultiSigWallet {
    using ECDSA for bytes32;

    address[2] public owners;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() external payable {}

    /// @notice 没有防止同一签名被多次重放使用的措施，因此攻击者可以重复调用该函数无限次，造成经济损失
    /// @param  _to _to
    function transfer(address _to, uint256 _amount, bytes[2] memory _sigs) external {
        bytes32 txHash = getTxHash(_to, _amount);
        require(_checkSigs(_sigs, txHash), "invalid sig");

        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function getTxHash(address _to, uint256 _amount) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount));
    }

    function _checkSigs(bytes[2] memory _sigs, bytes32 _txHash) private view returns (bool) {
        bytes32 ethSignedHash = toEthSignedMessageHash(_txHash);

        for (uint256 i = 0; i < _sigs.length; i++) {
            address signer = ethSignedHash.recover(_sigs[i]);
            bool valid = signer == owners[i];

            if (!valid) {
                return false;
            }
        }

        return true;
    }

    function toEthSignedMessageHash(bytes32 hash) public pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
