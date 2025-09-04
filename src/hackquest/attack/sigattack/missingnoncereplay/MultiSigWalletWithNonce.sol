// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title 通过Nonce防止签名攻击
 * @author
 * @dev
 */
contract MultiSigWalletWithNonce {
    using ECDSA for bytes32;

    address[2] public owners;
    // Record whether the signature has been used
    mapping(bytes32 => bool) public executed;

    constructor(address[2] memory _owners) payable {
        owners = _owners;
    }

    function deposit() external payable {}

    // Verifying the signature requires the nonce value
    function transfer(address _to, uint256 _amount, uint256 _nonce, bytes[2] memory _sigs) external {
        bytes32 txHash = getTxHash(_to, _amount, _nonce);
        require(!executed[txHash], "tx executed");
        require(_checkSigs(_sigs, txHash), "invalid sig");

        executed[txHash] = true;

        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function getTxHash(address _to, uint256 _amount, uint256 _nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), _to, _amount, _nonce));
    }

    function _checkSigs(bytes[2] memory _sigs, bytes32 _txHash) private view returns (bool) {
        // ...
    }
}
