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

    function swap() external {}

    function addLiquidity() external {}

    function removeLiquidity() external {}
}
