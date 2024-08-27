// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attacker {
    // This function simulates the rejection of ether when the attacker contract
    // is sent ether by the vulnerable contract.
    receive() external payable {
        revert("Rejecting Ether");
    }
}
