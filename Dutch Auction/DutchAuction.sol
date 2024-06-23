// SPDX-License-Identifier: MIT

// Deployment details :
//   NFT address :
//   Auction Address :

pragma solidity ^0.8;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    // Dutch Auction is type of auction in which the price of the asset decreases by time.
    // This decrement is decided by the discount factor, which increses by time.
    // A buyer can wait until the price of the asset reaches the desired or affordable price.
    // But it has be bought before the auction expires or any other buyer buys it.

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

    function getPrice() public view returns (uint) {
        uint elapsedTime = block.timestamp - startAt;
        uint discount = discountRate * elapsedTime;
        return startingPrice - discount;
    }

    function buy() public payable {
        require(block.timestamp < expiresAt, " Auction Expired !!");

        uint price = getPrice();

        require(msg.value >= price, "Not enough eth sent !!");
        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        //selfdestruct(seller);
    }
}
