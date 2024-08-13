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
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    block.number
                )
            )
        );
        lastRandomNumber = random;
        uint256 winnerIndex = random % participants.length;
        winner = participants[winnerIndex];

        // Reset participants for next lottery round
        delete participants;
    }
}
