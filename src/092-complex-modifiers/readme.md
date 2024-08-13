# Complex Modifiers

### Complex Modifiers in Solidity

Modifiers in Solidity are a powerful feature that allow you to change the behavior of functions. However, it's important to use them correctly to avoid potential issues. One key guideline is to use modifiers primarily for input validation with `require` statements and avoid including substantive logic within them. Here's why:

1. **Order of Execution**: Modifiers are executed before the function body. If a modifier contains substantive logic, it will be executed before any input validation done at the start of the function body. This can lead to unexpected behavior or security vulnerabilities.

2. **Readability and Maintainability**: Keeping modifiers simple and focused on input validation makes the code easier to read and maintain. Complex logic in modifiers can obscure the purpose of the function and make the code harder to understand.

### Example

Consider the following example of a simple modifier used for input validation:

```solidity
pragma solidity ^0.8.0;

contract Example {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
```

In this example, the `onlyOwner` modifier is used to ensure that only the contract owner can call the `changeOwner` function. The modifier contains a `require` statement for input validation and no substantive logic.

### Avoiding Complex Modifiers

Now, let's look at an example of a complex modifier that should be avoided:

```solidity
modifier complexModifier() {
    // Substantive logic
    if (someCondition) {
        doSomething();
    }
    require(someOtherCondition, "Condition not met");
    _;
}
```

In this case, the modifier contains substantive logic (`if (someCondition) { doSomething(); }`) before the `require` statement. This can lead to unexpected behavior if `someCondition` is true but `someOtherCondition` is false, causing the function to execute `doSomething()` before failing the `require` check.

### Best Practices

To avoid issues with complex modifiers, follow these best practices:

1. **Use Modifiers for Input Validation**: Keep modifiers focused on input validation using `require` statements.
2. **Avoid Substantive Logic**: Do not include substantive logic in modifiers. Instead, place such logic within the function body.
3. **Keep Modifiers Simple**: Ensure that modifiers are simple and easy to understand.

By adhering to these guidelines, you can write more secure and maintainable smart contracts.

