# Solidity Sneakily Makes Some Literals `uint8` Vulnerability

In Solidity, certain literals can be implicitly cast to `uint8`, which can lead to unexpected behavior and potential reverts. This often occurs with the ternary operator.

#### Example of Vulnerable Code

Here's an example of a vulnerable function:

```solidity
function result(bool inp) external pure returns (uint256) {
    return uint256(255) + (inp ? 1 : 0);
}
```

In this code, the ternary operator returns a `uint8` value. When `inp` is `true`, the expression `inp ? 1 : 0` evaluates to `1`, which is implicitly cast to `uint8`. Adding this `uint8` value to `uint256(255)` can cause unexpected behavior and potential reverts.

#### Prevention

To prevent this issue, explicitly cast the literals to the desired type before using them in expressions.

#### Example of Improved Code

Here's an improved version of the function that explicitly casts the literals:

```solidity
function result(bool inp) external pure returns (uint256) {
    return uint256(255) + (inp ? uint256(1) : uint256(0));
}
```

By explicitly casting `1` and `0` to `uint256`, the ternary operator returns a `uint256` value, preventing unexpected behavior and potential reverts.

#### Key Takeaways

- **Explicit Casting**: Always explicitly cast literals to the desired type before using them in expressions, especially with the ternary operator.
- **Be Mindful of Implicit Casting**: Understand how Solidity implicitly casts literals to avoid unexpected behavior.

By following these practices, you can avoid issues related to implicit casting of literals in Solidity and ensure that your smart contracts behave as expected.