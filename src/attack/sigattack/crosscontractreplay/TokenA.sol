// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract TokenA {
    using ECDSA for bytes32;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 TokenA";
    string public symbol = "SETA";
    uint8 public decimals = 18;
    mapping(address => uint256) nonces;

    constructor() {
        totalSupply = 2000;
        balanceOf[msg.sender] = 2000;
    }

    function _transfer(address to, uint256 value) internal {
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
    }

    function transfer(address to, uint256 value) public {
        require(balanceOf[msg.sender] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);

        _transfer(to, value);
    }

    function transferProxy(
        address _from,
        address _to,
        uint256 _value,
        uint256 _feeUgt,
        bytes memory signature
    ) public returns (bool) {
        bytes32 h = keccak256(
            abi.encodePacked(_from, _to, _value, _feeUgt, _useNonce(_from))
        );

        bool check_result = _checkSig(signature, h, _from);
        require(check_result, "signature is not right");

        if (
            balanceOf[_to] + _value < balanceOf[_to] ||
            balanceOf[msg.sender] + _feeUgt < balanceOf[msg.sender]
        ) revert();
        balanceOf[_to] += _value;

        balanceOf[msg.sender] += _feeUgt;

        balanceOf[_from] -= _value + _feeUgt;
        return true;
    }

    function getTxHash(
        address _from,
        address _to,
        uint256 _value,
        uint256 _feeUgt,
        uint256 _nonce
    ) public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(_from, _to, _value, _feeUgt, _nonce));
    }

    function _checkSig(bytes memory signature, bytes32 _txHash, address from)
    private
    pure
    returns (bool)
    {
        bytes32 ethSignedHash = toEthSignedMessageHash(_txHash);
        address signer = ethSignedHash.recover(signature);
        bool valid = signer == from;

        if (!valid) {
            return false;
        }
        return true;
    }

    function toEthSignedMessageHash(bytes32 hash) public pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function _useNonce(address owner) internal virtual returns (uint256 current) {
        current = nonces[owner];
        nonces[owner] += 1;
    }
}