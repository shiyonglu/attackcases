// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
// Denial of service attack, an attack can make fail line 13 by a fallback function that always fails and thus achieve "Denial of service"
// to keep his bidding position

// INSECURE
contract Auction {
    address payable public currentLeader;
    uint public highestBid;

    function bid() payable external {
        require(msg.value > highestBid);

        require(currentLeader.send(highestBid)); // Refund the old leader, if it fails then revert

        currentLeader = payable(msg.sender);
        highestBid = msg.value;
    }
}
