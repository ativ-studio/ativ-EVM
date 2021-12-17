// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AtivVotes is ERC20VotesComp, Ownable {
    constructor() ERC20("ATIV Votes", "ATIV") ERC20Permit("ATIV Votes") {}
    
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
}
