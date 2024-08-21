// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

contract GasLimitReachedExample {
    uint256 public largestWinner;

    // Function to select the next set of winners
    function selectNextWinners(uint256 _largestWinner) public {
        for (uint256 i = 0; i < _largestWinner; i++) {
            // Simulate complex logic by performing some operations
            uint256 x = i * i;
            x += i;
        }
        largestWinner = _largestWinner;
    }
}
