// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./ERC20.sol";

// Using ERC20 contract from the same directory
// We can also use OpenZeppelin's ERC20 contract by importing it.
// Here I have create my own ERC20 contract
contract MyToken is ERC20 {
      constructor(string memory _name, string memory _symbol, uint8 _decimals)
        ERC20(_name, _symbol, _decimals)
       {
       // Minting 500 tokens to msg.sender's address
       
        _mint(msg.sender, 500*(10 ** uint256(decimals)));

      }
}
