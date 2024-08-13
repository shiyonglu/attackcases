# Incorrect Parameter Order

Incorrect parameter order is a common issue in Solidity that can lead to unexpected behavior and vulnerabilities. This occurs when the order of parameters in a function call does not match the order of parameters in the function definition. Let's explore this in detail.

### The Vulnerability

When parameters are passed to a function in the wrong order, the function may receive incorrect values, leading to unintended behavior. This can be particularly problematic in functions that involve sensitive operations, such as token transfers or access control.

### Example

Consider the following function definition:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function transfer(address recipient, uint256 amount) public {
        // Transfer logic
    }
}
```

If the function is called with parameters in the wrong order, it can lead to unexpected behavior:

```solidity
example.transfer(100, recipient); // Incorrect parameter order
```

In this case, the function will receive `100` as the `recipient` address and `recipient` as the `amount`, which is incorrect.

### Prevention

To prevent issues related to incorrect parameter order, follow these best practices:

1. **Use Named Parameters**: When calling functions, use named parameters to ensure that the correct values are passed to the correct parameters.

   ```solidity
   example.transfer({recipient: recipient, amount: 100});
   ```

2. **Review Function Calls**: Carefully review function calls to ensure that the parameters are passed in the correct order.

3. **Use Descriptive Names**: Use descriptive parameter names to make it clear what each parameter represents.

### Example Prevention

Here's an example of a function call with named parameters:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function transfer(address recipient, uint256 amount) public {
        // Transfer logic
    }
}

contract Caller {
    Example example;

    function callTransfer(address recipient, uint256 amount) public {
        example.transfer({recipient: recipient, amount: amount});
    }
}
```

In this example, using named parameters ensures that the correct values are passed to the correct parameters, preventing issues related to incorrect parameter order.

By following these guidelines, you can minimize the risk of incorrect parameter order and ensure that your smart contracts behave as expected.

### Reference

https://scsfg.io/hackers/incorrect-parameter-order/
