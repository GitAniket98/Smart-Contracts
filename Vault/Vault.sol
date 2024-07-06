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

    function deposit(uint256 _amount) external {
        // a = amount
        // T = total supply
        // B = balance of token before deposit
        // s = shares to mint

        // (T + s)/T = (B + a)/B

        // s = (a * T) / B

        uint256 shares;

        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _shares) external {
        // a = amount
        // T = total supply
        // B = balance of token before deposit
        // s = shares to burn

        // (T - s)/T = (B - a)/B
        // a = (s*B)/T

        uint256 amount = (_shares * token.balanceOf(address(this))) /
            totalSupply;

        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}
