//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../legacy-contracts/ERC721A.sol";

contract Collection is Ownable, ReentrancyGuard, ERC721A {

    using Strings for uint256;

    string _baseTokenURI;

    uint256 public _price = 0.01 ether;

    bool public _paused;

    uint256 public maxSupply = 10;

    constructor(string memory baseURI) ERC721A("Collection", "CTN") {
        _baseTokenURI = baseURI;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function sstPaused(bool val) external onlyOwner {
        _paused = val;
    }

    function setCost(uint256 _cost) external onlyOwner {
        _price = _cost;
    }

    function setBaseURI(string memory _uri) external onlyOwner {
        _baseTokenURI = _uri;
    }

    function mint(uint256 quantity) external payable nonReentrant {
        uint256 supply = totalSupply();
        require(!_paused, "Contract paused");
        require(supply + quantity <= maxSupply, "Exceed maximum supply");
        require(msg.value == _price * quantity, "Incorrect Ether amount");
        require(quantity <= 5, "Exceed max mintable amount");
        _mint(msg.sender, quantity);
    }

    function reserveNFTs(uint256 _amount) external onlyOwner nonReentrant {
        require(totalSupply() + _amount <= maxSupply, "Action not completed");
        _mint(msg.sender, _amount);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token nonexistent");
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length >0 ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), ".json")) : "";
    }

    function withdraw() public onlyOwner nonReentrant {
        uint256 amount = address(this).balance;
        (bool sent, ) = payable(owner()).call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

