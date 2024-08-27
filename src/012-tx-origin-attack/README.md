# What is Tx Origin Attack?

A **Tx Origin Attack** in Solidity exploits the `tx.origin` variable, which is often misused for authentication purposes. The `tx.origin` is a global variable in Solidity that returns the address of the original external account (EOA) that initiated the transaction. 

### How the Attack Works:
1. **Basic Concept**:
   - An attacker tricks the contract into thinking that the transaction is coming from a trusted source by exploiting the `tx.origin` variable.
   - The contract might have a function that checks if `tx.origin` is equal to the owner’s address, allowing sensitive actions like transferring funds if the check passes.

2. **Exploitation Scenario**:
   - Suppose there's a contract `A` that uses `tx.origin` to verify the owner:
     ```solidity
     function withdraw() public {
         require(tx.origin == owner);
         msg.sender.transfer(this.balance);
     }
     ```
   - An attacker creates a malicious contract `B` and convinces the owner of contract `A` to interact with it, perhaps by calling a function that seems harmless.
   - Within this function, the attacker’s contract `B` calls the `withdraw` function of contract `A`.
   - Since `tx.origin` points to the original caller (the owner), not `msg.sender` (which would be contract `B`), the condition `tx.origin == owner` passes, and the funds are transferred to `msg.sender`, which is under the control of the attacker.

### Mitigation:
To prevent a `tx.origin` attack, the code should avoid using `tx.origin` for authentication and instead rely on `msg.sender`. Here's how you can modify the original contract to prevent the attack:


```solidity
function withdraw() public {
    require(msg.sender == owner, "Not authorized");
    payable(msg.sender).transfer(address(this).balance);
}
```

The `require(msg.sender == owner, "Not authorized");` line ensures that only the owner can call the `withdraw()` function. Since the check is now on `msg.sender`, even if another contract tries to call this function, the `msg.sender` would be that contract's address, not the original EOA (externally owned account), preventing unauthorized access.

### Additional Best Practices:
**Use OpenZeppelin's `Ownable` Contract**: For a more robust and tested implementation, you can use OpenZeppelin's `Ownable` contract, which handles ownership and access control securely.
  
  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  import "@openzeppelin/contracts/access/Ownable.sol";

  contract SecureContract is Ownable {
      function withdraw() public onlyOwner {
          payable(owner()).transfer(address(this).balance);
      }

      // Function to receive Ether
      receive() external payable {}
  }
  ```


By making these changes, the contract is protected against `tx.origin` attacks, ensuring that only the legitimate owner can withdraw funds or perform other sensitive actions.
