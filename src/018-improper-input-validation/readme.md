# Improper Input Validation Example

This project demonstrates the issue of improper input validation in Solidity smart contracts. Input validation is crucial for controlling what data is passed to a contract's functions. Failing to validate inputs properly can lead to serious vulnerabilities.

## Overview

The `UnsafeBank` contract allows users to deposit and withdraw funds. However, the contract does not properly validate inputs, allowing users to withdraw funds from arbitrary accounts.

### Problematic Contract Example

The `UnsafeBank` contract has the following functions:

- `deposit`: Allows users to deposit funds into the contract on behalf of any address.
- `withdraw`: Allows users to withdraw funds from any address without proper validation.

#### ImproperInputValidation.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnsafeBank {
    mapping(address => uint256) public balances;

    // Allow depositing on other's behalf
    function deposit(address for) public payable {
        balances[for] += msg.value;
    }

    // Function to withdraw funds from an arbitrary account
    function withdraw(address from, uint256 amount) public {
        require(balances[from] >= amount, "Insufficient balance");

        balances[from] -= amount;
        payable(msg.sender).call{value: amount}("");
    }
}
