// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * 我们的目标是触发下溢。假设我们当前有 20 个代币，我们只需要转账一个比 20 大的数量，比如 21。
 * await contract.transfer("0x0000000000000000000000000000000000000000", 21)
 */
contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        // 溢出
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
