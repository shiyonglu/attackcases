# Dos > Offline Owner

### The Problem: Offline Owner in Smart Contracts

In the context of smart contracts, the term "Offline Owner" refers to a scenario where the owner or an authority of a smart contract system becomes unavailable or loses access to their private key. This can lead to several issues:

1. **Inoperability**: If the owner is responsible for critical functions such as contract upgrades, fund withdrawals, or administrative tasks, their absence can render the contract inoperable. This means that no one can perform these essential functions, potentially leading to a complete halt in the system's operations.

2. **Security Risks**: An offline owner can also pose security risks. For instance, if the contract requires the owner's approval for certain actions, the inability to obtain this approval can prevent necessary security measures from being implemented.

3. **Loss of Funds**: In cases where the owner controls access to funds, losing the private key can result in the permanent loss of those funds. This is particularly problematic in decentralized finance (DeFi) applications where large sums of money are often involved.

### Real-World Example: Parity Wallet Hack

A notable example of the "Offline Owner" issue causing problems is the **Parity Wallet hack in 2017**. In this incident, a user accidentally triggered a vulnerability in the Parity multi-signature wallet smart contract. This action resulted in the freezing of approximately \$150 million worth of Ether. The owner of the contract went offline, and without access to the private key, the funds became permanently inaccessible. This incident underscores the importance of designing smart contracts to handle scenarios where the owner might go offline or lose their private key.

### The Solution: Implementing Multi-Signature Wallets

One effective solution to mitigate the "Offline Owner" issue is to implement a multi-signature wallet. A multi-signature (multi-sig) wallet requires multiple parties to approve a transaction before it can be executed. This reduces the risk of the contract becoming inoperable if one owner goes offline or loses their private key.

#### Example Code

Here's an example of a multi-signature wallet implemented in Solidity:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint public required;

    struct Transaction {
        address destination;
        uint value;
        bool executed;
        uint confirmations;
    }

    mapping(uint => Transaction) public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;
    uint public transactionCount;

    modifier onlyOwner() {
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    modifier confirmed(uint transactionId, address owner) {
        require(confirmations[transactionId][owner], "Transaction not confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number of owners");

        for (uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid owner");
            owners.push(_owners[i]);
        }
        required = _required;
    }

    function isOwner(address account) public view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address destination, uint value) public onlyOwner {
        uint transactionId = transactionCount++;
        transactions[transactionId] = Transaction({
            destination: destination,
            value: value,
            executed: false,
            confirmations: 0
        });
    }

    function confirmTransaction(uint transactionId) public onlyOwner notExecuted(transactionId) {
        require(!confirmations[transactionId][msg.sender], "Transaction already confirmed");
        confirmations[transactionId][msg.sender] = true;
        transactions[transactionId].confirmations += 1;

        if (transactions[transactionId].confirmations >= required) {
            executeTransaction(transactionId);
        }
    }

    function executeTransaction(uint transactionId) public onlyOwner notExecuted(transactionId) confirmed(transactionId, msg.sender) {
        Transaction storage txn = transactions[transactionId];
        txn.executed = true;
        (bool success, ) = txn.destination.call{value: txn.value}("");
        require(success, "Transaction failed");
    }
}
```

### How It Works

1. **Owners and Required Confirmations**: The contract initializes with a list of owners and the number of required confirmations for a transaction to be executed.

2. **Submitting Transactions**: Any owner can submit a transaction, which includes the destination address and the value to be sent.

3. **Confirming Transactions**: Owners can confirm transactions. Once the required number of confirmations is reached, the transaction can be executed.

4. **Executing Transactions**: The transaction is executed only if it has the required number of confirmations and has not been executed already.

By requiring multiple owners to confirm a transaction, the risk of the contract becoming inoperable due to an offline owner is significantly reduced. This approach enhances the security and reliability of the smart contract system.
