// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./IRegistry.sol";

/*
 *
 *                          ,--,      ,--,
 *                     ,---.'|   ,---.'|
 *                ,---,|   | :   |   | :      ,---,         ,----..       ,---,.,-.----.    .--.--.
 *        ,---.,`--.' |:   : |   :   : |     '  .' \       /   /   \    ,'  .' |\    /  \  /  /    '.
 *       /__./||   :  :|   ' :   |   ' :    /  ;    '.    |   :     : ,---.'   |;   :    \|  :  /`. /
 *  ,---.;  ; |:   |  ';   ; '   ;   ; '   :  :       \   .   |  ;. / |   |   .'|   | .\ :;  |  |--`
 * /___/ \  | ||   :  |'   | |__ '   | |__ :  |   /\   \  .   ; /--`  :   :  |-,.   : |: ||  :  ;_
 * \   ;  \ ' |'   '  ;|   | :.'||   | :.'||  :  ' ;.   : ;   | ;  __ :   |  ;/||   |  \ : \  \    `.
 *  \   \  \: ||   |  |'   :    ;'   :    ;|  |  ;/  \   \|   : |.' .'|   :   .'|   : .  /  `----.   \
 *   ;   \  ' .'   :  ;|   |  ./ |   |  ./ '  :  | \  \ ,'.   | '_.' :|   |  |-,;   | |  \  __ \  \  |
 *    \   \   '|   |  ';   : ;   ;   : ;   |  |  '  '--'  '   ; : \  |'   :  ;/||   | ;\  \/  /`--'  /
 *     \   `  ;'   :  ||   ,/    |   ,/    |  :  :        '   | '/  .'|   |    \:   ' | \.'--'.     /
 *      :   \ |;   |.' '---'     '---'     |  | ,'        |   :    /  |   :   .':   : :-'   `--'---'
 *       '---" '---'                       `--''           \   \ .'   |   | ,'  |   |.'
 *                                                          `---`     `----'    `---'
 *
 *   Enjoy the journey...
 *
 */

contract Villager is ERC721Upgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;

    address public registry;
    string public baseURI;
    uint256 public mintPrice;

    event TokenMinted(
        address indexed minter,
        uint256 indexed tokenId,
        address indexed tba
    );
    event BaseURIUpdated(string indexed oldValue, string indexed newValue);
    event RegistryUpdated(address indexed oldValue, address newValue);

    function initialize() public initializer {
        __ERC721_init("Villagers", "VLG");
        __Ownable_init();

        registry = 0x000000006551c19487814612e58FE06813775758;
        baseURI = "ipfs://xxx/";
    }

    /**
     * @dev Sets the baseURI for token data
     */
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        emit BaseURIUpdated(baseURI, _newBaseURI);
        baseURI = _newBaseURI;
    }

    /**
     * @dev Minting requires the {player} address and that a token has not
     * been already minted by that player. Returns the new tokenID and emits
     * the event TokenMinted.
     */
    function mintItem(address player) external payable returns (uint256) {
        require(balanceOf(msg.sender) == 0, "Already Minted");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(player, newItemId);
        address tbAccount = IRegistry(registry).createAccount(
            registry,
            0,
            this.address,
            newItemId,
            1,
            1
        );
        emit TokenMinted(player, newItemId, tbAccount);
        return newItemId;
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
