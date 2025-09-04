// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MyNFT {
    struct Token {
        string name;
        string description;
        address owner;
    }

    mapping(uint256 => Token) private tokens;
    mapping(address => uint256[]) private ownerTokens;
    uint256 private nextTokenId = 1;

    function mint(string memory _name, string memory _description) public returns (uint256) {
        Token memory newNFT = Token(_name, _description, msg.sender);
        uint256 tokenId = nextTokenId;
        tokens[tokenId] = newNFT;
        ownerTokens[msg.sender].push(tokenId);
        nextTokenId++;
        return nextTokenId - 1;
    }

    function getNFT(uint256 _tokenId)
        public
        view
        returns (string memory name, string memory description, address owner)
    {
        require(_tokenId >= 1 && _tokenId < nextTokenId, "Invalid token ID");
        Token storage token = tokens[_tokenId];
        name = token.name;
        description = token.description;
        owner = token.owner;
        return (token.name, token.description, token.owner);
    }

    function getTokensByOwner(address _owner) public view returns (uint256[] memory) {
        return ownerTokens[_owner];
    }

    function transfer(address _to, uint256 _tokenId) public returns (bool) {
        require(_tokenId >= 1 && _tokenId < nextTokenId, "Invalid tokenID");
        require(_to != address(0), "Invalid recipient");
        Token storage token = tokens[_tokenId];
        require(token.owner == msg.sender, "You don't own this token");

        // Update ownership
        token.owner = _to;

        // Remove token from current owner's list
        deleteById(msg.sender, _tokenId);

        // Add token to new owner's list
        ownerTokens[_to].push(_tokenId);

        return true;
    }

    function deleteById(address account, uint256 _tokenId) internal {
        uint256[] storage ownerTokenList = ownerTokens[account];
        for (uint256 i = 0; i < ownerTokenList.length; i++) {
            if (ownerTokenList[i] == _tokenId) {
                // 将该 NFT ID 与数组最后一个元素互换位置，然后删除数组最后一个元素
                ownerTokenList[i] = ownerTokenList[ownerTokenList.length - 1];
                ownerTokenList.pop();
                break;
            }
        }
    }

    function burn(uint256 _tokenId) public {
        require(_tokenId >= 1 && _tokenId < nextTokenId, "Invalid token ID");
        Token storage token = tokens[_tokenId];
        require(token.owner == msg.sender, "You don't own this token");

        // Remove token from owner's list
        deleteById(msg.sender, _tokenId);

        // Delete the token
        delete tokens[_tokenId];
        // Optionally, you can also decrement the nextTokenId if you want to reuse IDs
    }
}
