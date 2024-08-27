// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract AccessControl {
    address public owner;

    // The initContract function is vulnerable because it can be called by anyone
    // at any time, potentially allowing an attacker to take control of the contract.
    function initContract() public {
        owner = msg.sender;
    }
}

contract AccessControlSecureV1 {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

contract AccessControlSecureV2 {
    address public owner;
    bool public isInitialized;

    // The initContract function can only be called once and only by the
    // contract deployer, ensuring proper access control.
    function initContract() public {
        require(!isInitialized, "Contract is already initialized");
        owner = msg.sender;
        isInitialized = true;
    }
}
