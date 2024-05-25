// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.24;

import {ERC1155Upgradeable, ContextUpgradeable, IERC1155Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import {MANAGER_ROLE, MINTER_ROLE, GAME_LOGIC_CONTRACT_ROLE} from "../../Constants.sol";
import {IGameItems, ID} from "./IGameItems.sol";

/** @title ERC1155 contract for Game Items */
contract GameItems is IGameItems, ERC1155Upgradeable {
    /** TYPES **/
    struct TypeInfo {
        bool recyclable;
        uint256 mints;
        uint256 burns;
        uint256 maxSupply;
    }

    constructor() {
        // Do notthing
    }

    /** External Methods */

    /**
     * @return Contract metadata URI for the NFT contract, used by NFT marketplaces to display collection inf
     */
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    /**
     * Mints a ERC1155 token
     *
     * @param to        Recipient of the token
     * @param id        Id of token to mint
     * @param amount    Quantity of token to mint
     */
    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external override onlyRole(MINTER_ROLE) whenNotPaused {
        _safeMint(to, id, amount);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        _mintBatch(to, ids, amounts, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        _mintBatch(to, ids, amounts, "");
    }

    /**
     * Burn a token - any payment / game logic should be handled in the game contract.
     *
     * @param from      Account to burn from
     * @param id        Id of the token to burn
     * @param amount    Quantity to burn
     */
    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external override onlyRole(GAME_LOGIC_CONTRACT_ROLE) whenNotPaused {
        typeInfo[id].burns += amount;
        _burn(from, id, amount);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external onlyRole(GAME_LOGIC_CONTRACT_ROLE) whenNotPaused {
        _burnBatch(from, ids, amounts);
    }

    /** @return Token metadata URI for the given Id */
    function uri(uint256 id) public view override returns (string memory) {
        return _tokenURI(id);
    }

    /**
     * @param id  Id of the type to get data for
     *
     * @return How many of the given token id have been minted
     */
    function minted(
        uint256 id
    ) external view virtual override(IGameItems) returns (uint256) {
        return typeInfo[id].mints;
    }
}
