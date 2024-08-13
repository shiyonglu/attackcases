# Unexpected Ether Transfers (Force Feeding)

Unexpected Ether transfers, also known as force-feeding, occur when a smart contract receives Ether without explicitly accepting it through its functions. This can disrupt the contract's internal accounting and security assumptions. Let's explore how this happens and how to mitigate it.

### How Force-Feeding Works

There are several ways a smart contract can receive Ether unexpectedly:

1. **Selfdestruct**: When the `SELFDESTRUCT` opcode is called, the balance of the calling address is sent to the specified address, bypassing any Solidity-level checks. This means a contract can receive Ether even if it has no payable functions.

   ```solidity
   pragma solidity ^0.8.0;

   contract ForceFeed {
       function forceSend(address payable target) public payable {
           selfdestruct(target);
       }
   }
   ```

2. **Pre-calculated Deployments**: The address of a newly deployed contract is generated deterministically. An attacker can send Ether to this address before the contract is deployed.

3. **Block Rewards and Coinbase**: An attacker with mining capabilities can set the target address as their coinbase, causing block rewards to be added to the contract's balance.

### Example

Consider a contract that seemingly disallows direct payments:

```solidity
pragma solidity ^0.8.0;

contract Vulnerable {
    receive() external payable {
        revert();
    }

    function somethingBad() external {
        require(address(this).balance > 0, "No Ether balance");
        // Do something bad
    }
}
```

Even though the contract reverts any direct payments, it can still receive Ether through `selfdestruct` or other methods, potentially triggering the `somethingBad` function.

### Mitigation

To mitigate the risks associated with unexpected Ether transfers, follow these best practices:

1. **Avoid Exact Balance Checks**: Do not rely on exact comparisons to the contract's Ether balance. Instead, use internal accounting to track balances.

2. **Use Safe Patterns**: Implement safe patterns that do not depend on the contract's balance for critical logic.

3. **Monitor and Audit**: Regularly monitor and audit the contract's balance and transactions to detect any unexpected Ether transfers.

By following these guidelines, you can minimize the risk of unexpected Ether transfers and ensure the security and reliability of your smart contracts.



Source: Conversation with Copilot, 8/13/2024
(1) Unexpected Ether - Smart Contract Security Field Guide. https://scsfg.io/hackers/unexpected-ether/.
(2) Solidity Security: Comprehensive list of known attack vectors and .... https://blog.sigmaprime.io/solidity-security.html.
(3) Self-Destruct Exploit: Forced Ether Injection in Solidity Contracts. https://www.immunebytes.com/blog/self-destruct-exploit-forced-ether-injection-in-solidity-contracts/.