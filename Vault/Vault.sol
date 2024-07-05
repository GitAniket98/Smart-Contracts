// SPDX-License-Identifier : MIT

pragma solidity ^0.8.10;

import "Smart-Contracts/ERC20 Token/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint256 _amount) private {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function _burn(address _from, uint256 _amount) private {
        totalSupply -= _amount;
        balanceOf[_from] -= _amount;
    }
}
