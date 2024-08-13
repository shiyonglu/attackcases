# MixedAccounting Vulnerability Documentation
Introduction
This document details the vulnerability present in the MixedAccounting smart contract, which demonstrates the issue of mixed accounting methods for tracking Ether balances within a smart contract. The vulnerability allows for discrepancies between the contract's internal balance tracking and the actual Ether balance due to forced Ether transfers.

# Vulnerability Description
The MixedAccounting contract uses an internal variable myBalance to track deposits made through its deposit() function. Additionally, it provides functions to introspect the contract's actual Ether balance (myBalanceIntrospect()) and to return the internal balance (myBalanceVariable()). A comparison function (notAlwaysTrue()) checks if these two balances are equal.

# Vulnerability Details
Lack of Receive or Fallback Function: The contract does not include a receive or fallback function, meaning direct Ether transfers to the contract will revert.
Forced Ether Transfers: Ether can be forcefully sent to the contract using the selfdestruct function from another contract. This will increase the contract's actual Ether balance (myBalanceIntrospect()) without updating the internal myBalance variable.
Inconsistent Balances: Due to the possibility of forced Ether transfers, the internal balance (myBalance) and the actual Ether balance (myBalanceIntrospect()) can become inconsistent. This inconsistency is demonstrated by the notAlwaysTrue() function, which will return false when the balances do not match.
