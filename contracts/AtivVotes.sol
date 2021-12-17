// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AtivVotes is ERC20VotesComp, Ownable {
    constructor() ERC20("ATIV Votes", "ATIV") ERC20Permit("ATIV Votes") {}
    
    /// @dev MasterChef address.
    address public masterChef;

    function init(address masterChef_) public {
        masterChef = masterChef_;
    }

    function mint(address account, uint256 amount) public {
        require(msg.sender == masterChef, "invalid address.");

        _mint(account, amount);
    }

    function migrateFrom(address account, uint256 amount) public onlyOwner {        
        _mint(account, amount);
    }

    function migrateTo(address account, uint256 amount) public onlyOwner {        
        _burn(account, amount);
    }
}
