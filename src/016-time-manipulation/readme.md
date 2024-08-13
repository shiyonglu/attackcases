# Timestamp Manipulation Example

This project demonstrates the issue of relying on block timestamps for critical logic in Solidity smart contracts. Miners can manipulate block timestamps within a certain range, potentially exploiting contracts that rely on `block.timestamp` or `now`.

## Overview

The `TimestampManipulation` contract implements a simple game where participants can join, and a winner is picked based on a "random" number generated using block properties. This method of generating randomness is insecure and can be exploited.

### Real-World Impact

- **GovernMental**: A contract that had issues due to timestamp manipulation.
- **Example Scenario**: A game that pays out the very first player at midnight. A malicious miner includes their attempt to win the game and sets the block's timestamp to midnight, effectively exploiting the contract.

### Problematic Contract Example

The `TimestampManipulation` contract uses the following logic:

- The `play` function checks if the current timestamp is greater than a specific value.
- If true, it allows the first player to call the function to win 1 Ether.

#### 016-time-manipulation/TimestampManipulation.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimestampManipulation {
    bool public neverPlayed = true;
    address public winner;

    // The play function can be exploited by miners due to reliance on block.timestamp
    function play() public {
        require(block.timestamp > 1721763200 && neverPlayed == true, "Conditions not met");
        neverPlayed = false;
        winner = msg.sender;
        payable(msg.sender).transfer(1 ether);
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {}

    // Fallback function to accept Ether
    fallback() external payable {}
}
