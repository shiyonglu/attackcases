# Bad Randomness Example

This project demonstrates the issue of using block properties for generating randomness in Solidity smart contracts. Using block properties such as `block.timestamp`, `block.difficulty`, and `block.number` for randomness is considered bad practice due to their predictability and potential manipulation by miners.

## Overview

The contract `BadRandomness` implements a simple lottery where participants can join, and a winner is picked based on a "random" number generated using block properties. This method of generating randomness is insecure and can be exploited.

### Problematic Contract Example

The `BadRandomness` contract uses the following block properties to generate a "random" number:

- `block.timestamp`: The current block timestamp.
- `block.difficulty`: The current block difficulty.
- `block.number`: The current block number.

These values are used to create a "random" number, which is then used to select a winner from the participants.

#### BadRandomness.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BadRandomness {
    address public winner;
    uint256 public lastRandomNumber;

    // Array to store participants
    address[] public participants;

    // Function to join the lottery
    function joinLottery() public {
        participants.push(msg.sender);
    }

    // Function to pick a winner
    function pickWinner() public {
        require(participants.length > 0, "No participants in the lottery");

        // Bad randomness using block properties
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, block.number)));
        lastRandomNumber = random;
        uint256 winnerIndex = random % participants.length;
        winner = participants[winnerIndex];

        // Reset participants for next lottery round
        participants = new address ;
 }
