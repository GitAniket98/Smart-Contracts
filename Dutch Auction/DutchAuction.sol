// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IERC721 {
    function transferFrom(address _from, address _to, address _nftId) external;
}

contract DutchAuction {
    uint256 public constant DURATION = 7 days;
    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;

    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;

        require(
            _startingPrice >= _discountRate * DURATION,
            "Starting price is less than discount"
        );

        nft = IERC721(_nft);
        nftId = _nftId;
    }
}
