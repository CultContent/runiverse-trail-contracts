// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/** @title ERC1155 contract for Game Items */
contract GameItems is
    Initializable,
    UUPSUpgradeable,
    ERC1155Upgradeable,
    OwnableUpgradeable
{
    mapping(uint256 => string) public tokenURI;
    mapping(address => uint256) public itemCount;

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC1155_init("");
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function mint(
        uint256 tokenId,
        string memory tokenUri,
        bytes memory data
    ) public returns (uint256) {
        tokenURI[tokenId] = tokenUri;
        itemCount[msg.sender] = itemCount[msg.sender]++;
        _mint(msg.sender, tokenId, 1, data);
        return tokenId;
    }

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /**
     * @dev Contract-level metadata
     */
    function contractURI() public view returns (string memory) {
        return string(abi.encodePacked(super.uri(0), "contract.json"));
    }

    /**
     * @dev Only allows the contract owner to upgrade
     */
    function _authorizeUpgrade(
        address _newImplementation
    ) internal override onlyOwner {}
}
