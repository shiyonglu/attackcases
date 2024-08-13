# Write to Arbitrary Storage Location



### Sources




### Write to Arbitrary Storage Location

Writing to arbitrary storage locations in Solidity can lead to serious vulnerabilities, as it allows unauthorized users to manipulate the contract's storage. This can result in unauthorized access, data corruption, and other security issues. Let's explore this in detail.

Only authorized addresses should have access to write to sensitive storage locations. If there isn't proper authorization checks throughout the contract, a malicious user may be able to overwrite sensitive data. However, even if there are authorization checks for writing to sensitive data, an attacker may still be able to overwrite the sensitive data via insensitive data. This could give an attacker access to overwrite important variables such as the contract owner. 

To prevent this from occurring, we not only want to protect sensitive data stores with authorization requirements, but we also want to ensure that writes to one data structure cannot inadvertently overwrite entries of another data structure.

For an example, try [Ethernaut - Alien Codex](https://ethernaut.openzeppelin.com/level/19). If it's too hard, see [this walkthrough (SPOILER)](https://github.com/theNvN/ethernaut-openzeppelin-hacks/blob/main/level_19_Alien-Codex.md).

### How It Works

In Solidity, each variable is stored at a specific storage slot. If an attacker can write to arbitrary storage locations, they can overwrite critical data, such as the contract owner or balances, leading to potential exploits.

### Example

Consider the following vulnerable contract:

```solidity
pragma solidity ^0.8.0;

contract Vulnerable {
    uint256[] public data;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function updateData(uint256 index, uint256 value) public {
        data[index] = value; // Vulnerable to arbitrary storage write
    }
}
```

In this example, the `updateData` function allows writing to any index of the `data` array. If the index is not properly checked, an attacker can write to arbitrary storage locations, potentially overwriting the `owner` address.

### Prevention

To prevent writing to arbitrary storage locations, follow these best practices:

1. **Validate Indices**: Ensure that indices are within the valid range before writing to storage.

   ```solidity
   function updateData(uint256 index, uint256 value) public {
       require(index < data.length, "Index out of bounds");
       data[index] = value;
   }
   ```

2. **Use Mappings**: Use mappings instead of arrays for dynamic data storage, as mappings do not have the same vulnerability to arbitrary storage writes.

   ```solidity
   mapping(uint256 => uint256) public data;
   ```

3. **Avoid Direct Storage Writes**: Avoid writing directly to storage locations using assembly or low-level operations unless absolutely necessary and ensure proper validation.

### Example Prevention

Here's an example of a safer contract:

```solidity
pragma solidity ^0.8.0;

contract Safe {
    uint256[] public data;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function updateData(uint256 index, uint256 value) public {
        require(index < data.length, "Index out of bounds");
        data[index] = value;
    }
}
```

In this example, the `updateData` function includes a validation check to ensure that the index is within the valid range, preventing arbitrary storage writes.

### References

- [GuardRails: Write to Arbitrary Storage Location](https://docs.guardrails.io/docs/vulnerabilities/solidity/write_to_arbitrary_storage_location)
- [Stack Overflow: How to write to an arbitrary storage slot using assembly in Solidity](https://stackoverflow.com/questions/73504752/how-to-write-to-an-arbitrary-storage-slot-using-assembly-in-solidity-smart-contr)

By following these guidelines, you can minimize the risk of writing to arbitrary storage locations and ensure the security and reliability of your smart contracts.

If you have any further questions or need more examples, feel free to ask!

Source: Conversation with Copilot, 8/13/2024
(1) Solidity Storage: What You Need To Know. https://www.youtube.com/watch?v=i_LwhlFNSkI.
(2) Storage, Memory and Calldata | Solidity 0.8. https://www.youtube.com/watch?v=wOCIhzAuhgs.
(3) Arrays in Solidity: Storage Layout. https://www.youtube.com/watch?v=LID6-lGt6yY.
(4) Write to Arbitrary Storage Location | GuardRails. https://docs.guardrails.io/docs/vulnerabilities/solidity/write_to_arbitrary_storage_location.
(5) How to write to an arbitrary storage slot using assembly in Solidity .... https://stackoverflow.com/questions/73504752/how-to-write-to-an-arbitrary-storage-slot-using-assembly-in-solidity-smart-contr.
(6) undefined. https://remix.ethereum.org.
(7) undefined. https://docs.base.org/base-camp/docs/welcome.
(8) [SWC-124: Write to Arbitrary Storage Location](https://swcregistry.io/docs/SWC-124)
(9) [USCC 2017 Submission by doughoyte](https://github.com/Arachnid/uscc/tree/master/submissions-2017/doughoyte)