// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimestampManipulation {
    bool public neverPlayed = true;
    address public winner;

    // The play function can be exploited by miners due to reliance on block.timestamp
    function play() public {
        require(
            block.timestamp > 1721763200 && neverPlayed == true,
            "Conditions not met"
        );
        neverPlayed = false;
        winner = msg.sender;
        payable(msg.sender).transfer(1 ether);
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {}

    // Fallback function to accept Ether
    fallback() external payable {}
}
