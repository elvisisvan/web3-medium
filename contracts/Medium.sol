// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Medium is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public fees;
    
    constructor(
        string memory nftname,
        string memory nftsymbol,
        uint256 nftfees
    )
    ERC721(nftname, nftsymbol){
        fees = nftfees;
    }

    function safeMint(address to, string memory uri) public payable {
        require(msg.value >= fees, "Not enough MATIC");
        payable(owner()).transfer(fees);
        
        //mint NFT
        uint256 tokenId = _tokenIdCounter.current();
        tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        //return oversupplied fees
        uint256 contractBalance = address(this).balance;
        if(contractBalance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    //override functions
    function burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super.burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns(string memory)
    {
        return super.tokenURI(tokenId);
    }
}