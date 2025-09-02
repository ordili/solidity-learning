// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4);
}

interface IERC721 is IERC165 {
    function balanceOf(address account) external view returns (bool);

    function ownerOf(uint256 tokenId) external view returns (address);

    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);

    function transferFrom(address from, address to, uint256 tokenId) external returns (bool);

    function approve(address to, uint256 tokenId) external returns (bool);

    function getApproved(uint256 tokenId) external view returns (address);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovalForAll(address owner, address operator) external view returns (bool);
}

contract ERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event Approval(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    mapping(uint256 => address) internal _owners;
    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) internal _approves;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    constructor() {}

    function owner(uint256 tokenId) external view returns (address) {
        address addr = _owners[tokenId];
        require(addr != address(0), "token id doesn't exists.");
        return addr;
    }

    function balanceOf(address ownerAccount) external view returns (uint256) {
        return _balances[ownerAccount];
    }

    function transferFrom(address from, address to, uint256 tokenId) external returns (bool) {
        require(from != address(0), "from is zero.");
        require(to != address(0), "to is zero.");
        require(_owners[tokenId] == from, "from != owner");

        require(from == msg.sender || _approves[tokenId] == msg.sender, "not authorized.");

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        if (to.code.length > 0) {
            require(
                IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "")
                    == IERC721Receiver.onERC721Received.selector,
                "Recipient address don't support ERC721 tokens."
            );
        }
        emit Transfer(from, to, tokenId);

        return true;
    }
}
