# Deleting Structs That Contain Dynamic Datatypes Does Not Delete the Dynamic Data Vulnerability in Solidity

In Solidity, deleting a struct that contains dynamic datatypes (such as mappings or dynamic arrays) does not delete the dynamic data within those datatypes. This can lead to unexpected behavior and potential vulnerabilities.

#### Example of Vulnerable Code

Here's an example of a vulnerable contract:

```solidity
contract NestedDelete {

    mapping(uint256 => Foo) buzz;

    struct Foo {
        mapping(uint256 => uint256) bar;
    }

    Foo foo;

    function addToFoo(uint256 i) external {
        buzz[i].bar[5] = 6;
    }

    function getFromFoo(uint256 i) external view returns (uint256) {
        return buzz[i].bar[5];
    }

    function deleteFoo(uint256 i) external {
        // internal map still holds the data in the 
        // mapping and array
        delete buzz[i];
    }
}
```

In this code, the `delete` keyword is used to delete the `Foo` struct from the `buzz` mapping. However, the internal mapping `bar` within the `Foo` struct still holds the data.

#### Transaction Sequence

1. `addToFoo(1)`: Adds data to the `Foo` struct at index `1`.
2. `getFromFoo(1)`: Returns `6`, the value stored in the internal mapping.
3. `deleteFoo(1)`: Deletes the `Foo` struct at index `1`.
4. `getFromFoo(1)`: Still returns `6`, indicating that the internal mapping data was not deleted.

#### Prevention

To prevent this issue, you need to manually delete the dynamic data within the struct before deleting the struct itself.

#### Example of Improved Code

Here's an improved version of the contract that correctly deletes the dynamic data:

```solidity
contract ImprovedNestedDelete {

    mapping(uint256 => Foo) buzz;

    struct Foo {
        mapping(uint256 => uint256) bar;
    }

    Foo foo;

    function addToFoo(uint256 i) external {
        buzz[i].bar[5] = 6;
    }

    function getFromFoo(uint256 i) external view returns (uint256) {
        return buzz[i].bar[5];
    }

    function deleteFoo(uint256 i) external {
        // Manually delete the internal mapping data
        delete buzz[i].bar[5];
        // Now delete the struct
        delete buzz[i];
    }
}
```

In this improved version, the internal mapping data is manually deleted before deleting the `Foo` struct. This ensures that all dynamic data is correctly removed.

#### Key Takeaways

- **Manual Deletion**: Manually delete dynamic data within structs before deleting the struct itself.
- **Understand Storage Behavior**: Be aware of how Solidity handles storage and the limitations of the `delete` keyword.

By following these practices, you can avoid issues related to deleting structs with dynamic datatypes in Solidity and ensure that your smart contracts behave as expected.