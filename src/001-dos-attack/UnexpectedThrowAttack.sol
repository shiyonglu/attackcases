// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract MaliciousContract {
    // This contract deliberately fails on receiving Ether
    fallback() external payable {
        revert("Deliberate failure");
    }

    receive() external payable {
        revert("Deliberate failure");
    }
}
