// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import {ERC721} from "../lib/solmate/src/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

    error MintPriceNotPaid();
    error MaxSupply();
    error NonExistentTokenURI();

contract NFT is ERC721 {

    uint256 public constant MAX_CAPACITY = 10_000;
    uint256 public constant MINT_PRICE = 0.05 ether;
    uint256 public currentTokenId;

    string public baseURI;

    constructor(string memory _name, string  memory _symbol, string memory _baseURI) ERC721(_name, _symbol){
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256){
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }

        uint256 newItemId = ++currentTokenId;

        if (newItemId > MAX_CAPACITY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function tokenURI(uint256 tokenId) public virtual override view returns (string memory){

        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        if (bytes(baseURI).length > 0) {
            return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
        } else {
            return "";
        }
    }
}












