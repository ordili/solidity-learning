// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DeployAnyContract {
    event Deploy(address);

    constructor() {}
    receive() external payable {}

    function deploy(bytes memory _code) external payable returns (address addr) {
        assembly {
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        require(addr != address(0), "deploy failed");
        emit Deploy(addr);
    }

    function execute(address _target, bytes memory _data) external payable {
        (bool success,) = _target.call{value: msg.value}(_data);
        require(success, "Failed");
    }
}

contract TestContract {
    address public owner = msg.sender;

    constructor() payable {}

    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

contract Helper {
    function getBytecode() external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        return bytecode;
    }

    function getCalldata(address _owner) external pure returns (bytes memory) {
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}
