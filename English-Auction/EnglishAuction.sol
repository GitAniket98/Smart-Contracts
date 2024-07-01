// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed bidder, uint bidAmount);
    event Withdraw(address indexed bidder, uint256 amount);
    event End(address indexed bidWinner, uint256 bidAmount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint32 public endAt;

    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        highestBid = _startingBid;
        seller = payable(msg.sender);
    }

    function start() external {
        require(msg.sender == seller, "You are not seller");
        require(!started, "Auction already started");

        started = true;
        endAt = uint32(block.timestamp + 60);
        nft.transferFrom(seller, address(this), nftId);
        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, " msg.value < highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external payable {
        uint256 bal = bids[msg.sender];

        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external payable {
        require(started, "Not started");
        require(!ended, "Ended");
        require(block.timestamp >= endAt, "block.timestamp < endAt");

        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
