# Bypassing Contract Check: Understanding and Limitations

## Overview
In Solidity, developers sometimes need to determine whether an address is a smart contract or an externally owned account (EOA). This is often done by checking the bytecode size at the address. However, this method has several limitations and can lead to potential vulnerabilities. This document provides an overview of how to check if an address is a contract, the limitations of these methods, and potential risks.

## Methods for Checking if an Address is a Contract

### Using OpenZeppelin's Address Library

 # The testing coe is here:
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/CheckIfContract.sol";
import "../contracts/Create2Deployer.sol";

contract BypassContractCheck is Test {
    CheckIfContract public checkIfContract;
    Create2Deployer public create2Deployer;
    address attacker;

    function setUp() public {
        checkIfContract = new CheckIfContract();
        create2Deployer = new Create2Deployer();
        attacker = address(0x1234);
    }

    function testBypassContractCheck() public {
        // Bytecode of a simple contract
        bytes memory bytecode = hex"6080604052348015600f57600080fd5b5060006000fdfea2646970667358221220e2e22e1b5165c9b77e9c9e79aaf9c946fe8d93e10f0e2f8f49b499187d17c5e064736f6c634300080a0033";

        // Compute the future address
        bytes32 salt = bytes32(uint256(1234));
        bytes32 bytecodeHash = keccak256(bytecode);
        address futureAddress = create2Deployer.computeAddress(salt, bytecodeHash);

        // Check if futureAddress is a contract before deployment
        bool isContract = checkIfContract.addressIsContract(futureAddress);
        assertEq(isContract, false);

        // Deploy the contract to the computed address using CREATE2
        vm.startPrank(attacker);
        create2Deployer.deploy(uint256(salt), bytecode);
        vm.stopPrank();

        // Check if futureAddress is a contract after deployment
        isContract = checkIfContract.addressIsContract(futureAddress);
        assertEq(isContract, true);
    }
}
