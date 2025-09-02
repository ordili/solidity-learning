// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    string public name;
    uint8 public decimal;
    string public symbol;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimal) {
        name = _name;
        symbol = _symbol;
        decimal = _decimal;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance is insufficient.");
        unchecked {
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;
        }
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(allowance[sender][msg.sender] >= amount, "allowanced amount is insufficient.");
        allowance[sender][msg.sender] -= amount;
        unchecked {
            balanceOf[sender] -= amount;
            balanceOf[recipient] += amount;
        }
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance is insufficient.");
        allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    function mint(address to, uint256 amount) external returns (bool) {
        totalSupply += amount;
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(address from, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "balance is insufficient.");
        unchecked {
            totalSupply -= amount;
            balanceOf[from] -= amount;
        }
        emit Transfer(from, address(0), amount);
        return true;
    }
}
