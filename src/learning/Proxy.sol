// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LogicContract {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setNum(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract ProxyContract {
    uint256 public num;
    address public sender;
    uint256 public value;
    address public logicContract;

    constructor(address _logicContract) {
        logicContract = _logicContract;
    }

    function directCall(uint256 _num) external payable returns (bool) {
        bytes memory sig = abi.encodeWithSignature("setNum(uint256)", _num);
        (bool ret,) = logicContract.call{value: msg.value}(sig);
        require(ret, "call logic contract error.");
        return ret;
    }

    function delegateCall(uint256 _num) external returns (bool) {
        bytes memory sig = abi.encodeWithSignature("setNum(uint256)", _num);
        (bool ret,) = logicContract.delegatecall(sig);
        require(ret, "delegate call logic contract error.");
        return ret;
    }
}
