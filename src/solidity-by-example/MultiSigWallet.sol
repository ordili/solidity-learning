// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(
        address indexed owner, uint256 indexed txIndex, address indexed to, uint256 value, bytes data
    );

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint8 numConfirmations;
    }

    event ConfirmationTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 txIndex);
    event ExecuteTransaction(address indexed owner, uint256 txIndex);

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required.");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "numConfirmationsRequired is invalid."
        );
        uint256 size = _owners.length;
        for (uint256 i = 0; i < size;) {
            address _owner = _owners[i];
            require(_owner != address(0), "owner address is zero.");
            require(!isOwner[_owner], "owner duplicated.");

            isOwner[_owner] = true;
            owners.push(_owner);

            unchecked {
                ++i;
            }
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }
}
