# Short Address Attack Example

This project demonstrates the issue of short address attacks in Solidity smart contracts. These attacks exploit the fact that the Ethereum Virtual Machine (EVM) accepts incorrectly padded arguments, allowing attackers to manipulate the encoding of arguments before they are included in transactions.

## Overview

The `ShortAddressAttack` contract implements a simple token transfer function that is vulnerable to short address attacks. The function does not check the length of the recipient address, allowing attackers to use specially crafted addresses to manipulate the transaction arguments.

### Problematic Contract Example

The `ShortAddressAttack` contract uses the following logic:

- The `transfer` function transfers tokens from the sender to the recipient.
- It does not check the length of the recipient address, making it vulnerable to short address attacks.

#### ShortAddressAttack.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShortAddressAttack {
    mapping(address => uint256) public balances;

    // Function to deposit tokens into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerable transfer function that doesn't check the length of the address
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
