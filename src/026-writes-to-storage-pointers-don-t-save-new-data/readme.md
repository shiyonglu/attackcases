# Writes to Storage Pointers Don't Save New Data Vulnerability in Solidity

In Solidity, writing to storage pointers does not save new data to the underlying storage. This can lead to unexpected behavior and potential vulnerabilities.

#### Example of Vulnerable Code

Here's an example of a vulnerable contract:

```solidity
contract DoesNotWrite {
    struct Foo {
        uint256 bar;
    }
    Foo[] public myArray;

    function moveToSlot0() external {
        Foo storage foo = myArray[0];
        foo = myArray[1]; // myArray[0] is unchanged
        // we do this to make the function a state 
        // changing operation
        // and silence the compiler warning
        myArray[1] = Foo({bar: 100});
    }
}
```

In this code, it looks like the data in `myArray[1]` is copied to `myArray[0]`, but it isn't. The write to `foo` does not write to the underlying storage. If you comment out the final line in the function, the compiler will suggest turning the function into a view function, indicating that no state change is detected.

#### Prevention

To prevent this issue, avoid writing to storage pointers directly. Instead, use explicit assignments to ensure that the data is correctly written to storage.

#### Example of Improved Code

Here's an improved version of the contract that correctly writes to storage:

```solidity
contract CorrectWrite {
    struct Foo {
        uint256 bar;
    }
    Foo[] public myArray;

    function moveToSlot0() external {
        myArray[0] = myArray[1]; // Explicitly assign the value
        // we do this to make the function a state 
        // changing operation
        // and silence the compiler warning
        myArray[1] = Foo({bar: 100});
    }
}
```

In this improved version, the data in `myArray[1]` is explicitly assigned to `myArray[0]`, ensuring that the underlying storage is correctly updated.

#### Key Takeaways

- **Avoid Writing to Storage Pointers**: Directly writing to storage pointers does not update the underlying storage. Use explicit assignments instead.
- **Compiler Warnings**: Pay attention to compiler warnings and suggestions, as they can indicate potential issues in your code.

By following these practices, you can avoid issues related to writing to storage pointers in Solidity and ensure that your smart contracts behave as expected.