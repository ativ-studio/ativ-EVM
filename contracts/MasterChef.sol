// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./AtivVotes.sol";
import "./IPNFT.sol";

/**
 * @title MasterChef
 *
 * As you know, MasterChef is the master of Sushi.
 * He can make Sushi and he is a fair guy.
 *
 * However, He distributes ATIVs per NFT in this system.
 *
 * Master chef said:
 * Have fun reading it. Hopefully it's bug-free. God bless.
 */
contract MasterChef is Ownable {
    /// @dev The ATIV TOKEN!
    AtivVotes public ativ;

    /// @dev The IP NFT!
    IPNFT public ipnft;
    
    /// @dev Dev address.
    address public devaddr;

    // Fee. Default: 10%
    uint256 public feeNumerator = 10;
    uint256 public feeDenominator = 100;

    event Harvest(address indexed user, uint256 indexed musicId, uint256 amount);

    constructor(
        AtivVotes ativ_,
        IPNFT ipnft_,
        address devaddr_
    ) {
        ativ = ativ_;
        ipnft = ipnft_;
        devaddr = devaddr_;
    }

    /// @dev Update dev address by the previous dev.
    function dev(address devaddr_) public {
        require(msg.sender == devaddr, "dev: wut?");
        devaddr = devaddr_;
    }

    /// @dev View function to see pending ATIVs on frontend.
    function pendingAtiv(uint256 musicId_, uint256 tokenId_)
        public
        view
        returns (uint256)
    {
        uint256 musicId;
        uint256 gain;
        uint256 lastUpdatedEpoch;
        
        (musicId, gain, lastUpdatedEpoch) = ipnft.meta(tokenId_);
        if (musicId != musicId_) { return 0; }

        uint256 period = ipnft.epoch() - lastUpdatedEpoch;
        if (period <= 0) { return 0; }

        return period * gain;
    }

    /// @notice Harvest proceeds for transaction sender to `to`.
    /// @param musicId_ The ID of the music.
    /// @param tokenId_ The ID of the token.
    /// @param to Receiver of ATIV rewards.
    function harvest(uint256 musicId_, uint256 tokenId_, address to) public {
        uint256 pendingAtiv_ = pendingAtiv(musicId_, tokenId_);
        if (pendingAtiv_ == 0) { return; }

        ipnft.updateNftEpoch(tokenId_);

        ativ.mint(devaddr, pendingAtiv_ * feeNumerator / feeDenominator);
        ativ.mint(to, pendingAtiv_);

        emit Harvest(msg.sender, musicId_, pendingAtiv_);
    }
}
