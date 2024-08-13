# Ambiguous Evaluation Order

Ambiguous evaluation order refers to the uncertainty in the order in which expressions are evaluated in a programming language. In Solidity, this can lead to unexpected behavior and potential vulnerabilities if not handled carefully.

### Example

Consider the following example where the order of evaluation is ambiguous:

```solidity
pragma solidity ^0.8.0;

contract AmbiguousOrder {
    uint256 public a;
    uint256 public b;

    function setValues() public {
        a = 1;
        b = a + 1;
    }
}
```

In this example, the order in which `a` and `b` are assigned values is not guaranteed. Depending on the compiler and optimization settings, `b` might be assigned the value of `a` before `a` is set to 1, leading to unexpected results.

### Prevention

To avoid issues related to ambiguous evaluation order, follow these best practices:

1. **Separate Assignments**: Ensure that assignments are separated and do not depend on the order of evaluation.
   
   ```solidity
   function setValues() public {
       a = 1;
       b = a + 1;
   }
   ```

2. **Use Temporary Variables**: Use temporary variables to store intermediate results and ensure the correct order of evaluation.
   
   ```solidity
   function setValues() public {
       uint256 temp = 1;
       a = temp;
       b = temp + 1;
   }
   ```

3. **Avoid Complex Expressions**: Avoid using complex expressions that rely on the order of evaluation. Break them down into simpler, more predictable steps.

### Example Prevention

Here's an example of how to prevent ambiguous evaluation order:

```solidity
pragma solidity ^0.8.0;

contract ClearOrder {
    uint256 public a;
    uint256 public b;

    function setValues() public {
        uint256 temp = 1;
        a = temp;
        b = temp + 1;
    }
}
```

In this example, the use of a temporary variable ensures that the order of evaluation is clear and predictable.

By following these guidelines, you can avoid issues related to ambiguous evaluation order and ensure that your smart contracts behave as expected.

## Reference: 
https://scsfg.io/hackers/ambiguous-evaluation/