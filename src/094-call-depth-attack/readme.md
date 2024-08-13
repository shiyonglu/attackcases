# Call Depth Attack

A Call Depth Attack is a type of attack that exploits the limited call stack depth in Ethereum. In Ethereum, the call stack depth is limited to 1024 calls. An attacker can exploit this limitation by creating a contract that makes a large number of nested calls, causing the call stack to reach its limit. When the call stack limit is reached, any further calls will fail, potentially causing the targeted contract to behave unexpectedly or fail to execute critical functions.

### Example

Consider a contract that relies on making multiple nested calls:

```solidity
pragma solidity ^0.8.0;

contract Vulnerable {
    function nestedCall(uint256 depth) public {
        if (depth > 0) {
            nestedCall(depth - 1);
        }
    }

    function criticalFunction() public {
        // Critical logic that should not fail
    }
}
```

An attacker can create a contract that calls `nestedCall` with a large depth, causing the call stack to reach its limit. This can prevent the `criticalFunction` from executing properly.

### Fix in EIP 150

EIP 150, also known as the "Gas Cost Changes for IO-heavy Operations," introduced changes to the gas cost of certain operations to mitigate the risk of call depth attacks. One of the key changes was the introduction of a new opcode, `CALLDEPTH`, which allows contracts to check the current call depth and avoid making further calls if the depth is too high.

### Best Practices

To protect your contracts from call depth attacks, follow these best practices:

1. **Limit Nested Calls**: Avoid making a large number of nested calls in your contracts.
2. **Check Call Depth**: Use the `CALLDEPTH` opcode or similar mechanisms to check the current call depth and avoid making further calls if the depth is too high.
3. **Use Safe Libraries**: Use well-audited libraries and frameworks that implement best practices for call depth management.

By following these guidelines, you can minimize the risk of call depth attacks and ensure the security and reliability of your smart contracts.

