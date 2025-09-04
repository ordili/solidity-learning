// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

/**
 * 安全教训
 * 不要信任外部 view 函数的返回值
 * view 函数也可以有状态依赖的行为
 * 对于关键逻辑，应该缓存结果而不是多次调用
 * 考虑使用确定的、无状态的价格计算
 */
contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);
        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            // 这里不应该二次调用获取price，而是应该第一次调用的时候使用memory变量把price保存起来，然后使用保存的价格
            price = _buyer.price();
        }
    }
}
