## Overview

Solidity provides low-level functions like `call()`, `callcode()`, `delegatecall()`, and `send()`. These functions have different error handling mechanisms compared to regular Solidity functions. Instead of propagating errors and reverting the transaction, these functions return a boolean value (`false` on failure and `true` on success). If the return value is not checked, it can lead to unintended contract states.

### Real-World Impact

- **King of the Ether**: A contract that had issues due to unhandled low-level calls.
- **Etherpot**: Another example where low-level call mishandling led to vulnerabilities.

## Problematic Contract Example

The `FaultyWithdraw` contract demonstrates the issue when the return value of `send()` is not checked. If the `send()` function fails, the balance and `etherLeft` are still updated, leading to an incorrect state.

### FaultyWithdraw.sol

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FaultyWithdraw {
    mapping(address => uint256) public balances;
    uint256 public etherLeft;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        etherLeft += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        etherLeft -= _amount;
        // The return value of send() is not checked
        payable(msg.sender).send(_amount);
    }
}