# Shadowing State Variables

**Description**:
Shadowing state variables occurs when a variable in a child contract has the same name as a variable in a parent contract. This can lead to unintended behavior, as the child contract's variable can overshadow the parent contract's variable, causing confusion and potential errors.

### Example
Consider the following Solidity code snippet:

```solidity
contract ParentContract {
    uint public value = 1;
}

contract ChildContract is ParentContract {
    uint public value = 2; // Shadows the value variable in ParentContract
}
```

In this example, `ChildContract` inherits from `ParentContract`, and both contracts have a variable named `value`. The `value` variable in `ChildContract` shadows the `value` variable in `ParentContract`, leading to potential confusion and unintended behavior.

### Prevention
To prevent shadowing state variables, follow these best practices:

1. **Avoid Duplicate Names**: Ensure that variables in child contracts do not have the same names as variables in parent contracts.
2. **Use Different Naming Conventions**: Adopt naming conventions that differentiate variables in child contracts from those in parent contracts.
3. **Compiler Warnings**: Use Solidity compilers higher than version 0.6.0, as they can detect and prevent shadowing state variables¹.
4. **Code Reviews**: Conduct thorough code reviews to identify and address potential shadowing issues.
5. **Static Analysis Tools**: Utilize static analysis tools to detect shadowing and other vulnerabilities in your smart contracts.

By following these practices, you can minimize the risk of shadowing state variables and ensure the integrity of your smart contracts¹²³.

If you have any more questions or need further clarification, feel free to ask!

Source: Conversation with Copilot, 8/13/2024
(1) Smart contract shadowing state variables vulnerability. https://www.getsecureworld.com/blog/smart-contract-shadowing-state-variables-vulnerability/.
(2) shadowing-state-variables.md - GitHub. https://github.com/kadenzipfel/smart-contract-vulnerabilities/blob/master/vulnerabilities/shadowing-state-variables.md.
(3) Shadowing Inherited State Variables - Solidity by Example. https://solidity-by-example.org/shadowing-inherited-state-variables/.