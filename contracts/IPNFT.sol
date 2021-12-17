// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IPNFT is ERC721("IP NFT", "IPNFT"), Ownable {
    /**
     * @dev Metadata of NFT.
     *
     * - `musicId`: ID of music.
     * - `gain`: Amount of differential ATIV per NFT.
     * - `lastUpdatedEpoch`: Number of epoch when entering.
     */
    struct Meta {
        uint256 musicId;
        uint256 gain;
        uint256 createdEpoch;
        uint256 lastUpdatedEpoch;
    }

    mapping (uint256 => Meta) internal _meta;

    /// @dev Current epoch.
    uint256 public epoch;

    address dead = address(0x000000000000000000000000000000000000dEaD);

    /// @dev MasterChef address.
    address public masterChef;

    function init(address masterChef_) public {
        masterChef = masterChef_;
    }

    /**
     * @dev Get metadata of `tokenId`.
     */
    function meta(uint256 tokenId) public view returns (uint256, uint256, uint256) {
        return (_meta[tokenId].musicId, _meta[tokenId].gain, _meta[tokenId].lastUpdatedEpoch);
    }

    /**
     * @dev Get `musicId` of `_meta`.
     */
    function musicId(uint256 tokenId) public view returns (uint256) {
        return _meta[tokenId].musicId;
    }

    /**
     * @dev Get `gain` of `_meta`.
     */
    function gain(uint256 tokenId) public view returns (uint256) {
        return _meta[tokenId].gain;
    }

    /**
     * @dev Change `gain` of `_meta`.
     */
    function setGain(uint256 tokenId, uint256 gain_) public onlyOwner {
        _meta[tokenId].gain = gain_;
    }

    /**
     * @dev Mint NFT with amount of `musicId_` and `gain_`.
     */
    function mint(
        address to,
        uint256 tokenId,
        uint256 musicId_,
        uint256 gain_
    ) public onlyOwner {
        _meta[tokenId].musicId = musicId_;
        _meta[tokenId].gain = gain_;
        _meta[tokenId].createdEpoch = epoch;
        _meta[tokenId].lastUpdatedEpoch = epoch;

        _mint(to, tokenId);
    }

    function migrateFrom(
        address to,
        uint256 tokenId,
        uint256 musicId_,
        uint256 gain_
    ) public onlyOwner {
        _meta[tokenId].musicId = musicId_;
        _meta[tokenId].gain = gain_;
        _meta[tokenId].createdEpoch = epoch;
        _meta[tokenId].lastUpdatedEpoch = epoch;

        _mint(to, tokenId);
    }

    function migrateTo(
        address from,
        uint256 tokenId
    ) public onlyOwner {
        delete _meta[tokenId];

        _transfer(from, dead, tokenId);
    }

    /**
     * @dev Update `lastUpdatedEpoch` of `tokenId`.
     */
    function updateNftEpoch(uint256 tokenId) public {
        require(msg.sender == masterChef, "invalid address.");

        _meta[tokenId].lastUpdatedEpoch = epoch;
    }

    // /**
    //  * @dev Update current epoch.
    //  */
    // function updateEpoch() public onlyOwner {
    //     epoch++;
    // }

    /**
     * @dev Update current epoch.
     */
    function setEpoch(uint256 epoch_) public onlyOwner {
        epoch = epoch_;
    }
}
