# Historic Attacks > Constructor Names

### Historic Attacks: Constructor Names

In earlier versions of Solidity, there was a vulnerability related to constructor names that could lead to serious security issues. This vulnerability was fixed in Solidity v0.4.22. Let's explore this in detail.

### The Vulnerability

In Solidity versions prior to v0.4.22, constructors were defined by naming a function with the same name as the contract. This approach had a significant flaw: if the constructor name was misspelled or if the contract name was changed without updating the constructor name, the function would not be recognized as a constructor. Instead, it would become a regular public function that anyone could call, potentially leading to unauthorized access or control over the contract.

### Example

Consider the following contract with a misspelled constructor name:

```solidity
pragma solidity ^0.4.21;

contract Vulnerable {
    address public owner;

    // Intended constructor, but misspelled
    function Vulnreable() public {
        owner = msg.sender;
    }
}
```

In this example, the function `Vulnreable` is intended to be the constructor, but due to the misspelling, it is treated as a regular public function. This means anyone can call it and set themselves as the owner of the contract.

### Fix in Solidity v0.4.22

To address this issue, Solidity introduced a new syntax for defining constructors in version v0.4.22. Constructors are now defined using the `constructor` keyword, which eliminates the risk of misspelling:

```solidity
pragma solidity ^0.4.22;

contract Secure {
    address public owner;

    // Proper constructor definition
    constructor() public {
        owner = msg.sender;
    }
}
```


### Best Practices

To avoid issues related to constructor names, follow these best practices:

1. **Use the `constructor` Keyword**: Always use the `constructor` keyword to define constructors in Solidity.
2. **Review Contract Names**: Ensure that the contract name and constructor name match if using older versions of Solidity.
3. **Upgrade Solidity Version**: Use the latest stable version of Solidity to benefit from security improvements and bug fixes.

By adhering to these guidelines, you can ensure that your smart contracts are secure and free from vulnerabilities related to constructor names.



### References

-   [Sigmaprime: Constructors with Care](https://blog.sigmaprime.io/solidity-security.html#constructors)
-   [Trail of Bits: Wrong Constructor Name](https://github.com/crytic/not-so-smart-contracts/tree/master/wrong_constructor_name)
-   [SWC Registry: Incorrect Constructor Name](https://smartcontractsecurity.github.io/SWC-registry/docs/SWC-118)