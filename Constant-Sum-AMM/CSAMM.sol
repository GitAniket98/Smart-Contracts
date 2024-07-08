// SPDX-License-Identifier : MIT

pragma solidity ^0.8.13;

import "Smart-Contracts/ERC20 Token/IERC20.sol";

contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint public totalSupply;

    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function swap() external {}

    function addLiquidity() external {}

    function removeLiquidity() external {}
}
