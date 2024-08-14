# Floating Pragma Vulnerability

#### Description:
Floating pragma refers to the practice of not locking the Solidity compiler version in the contract code. This can lead to deploying contracts with different compiler versions than those used during testing, potentially introducing bugs and inconsistencies.

#### Example:
Consider the following Solidity code with a floating pragma:

```solidity
pragma solidity ^0.8.0;

contract Example {
    // Contract code here
}
```

In this example, the `^0.8.0` pragma allows the contract to be compiled with any version of the Solidity compiler from `0.8.0` to `0.8.x`. This can lead to inconsistencies if the contract is compiled with a different version than the one used during testing.

#### Prevention:
1. **Lock the Pragma Version**: Specify a fixed compiler version in your Solidity code to ensure consistency. For example:
   ```solidity
   pragma solidity 0.8.0;
   ```
   This ensures that the contract is always compiled with the same version of the Solidity compiler.

2. **Consider Known Bugs**: Review known bugs for the chosen compiler version and ensure they do not affect your contract. You can find this information in the [Solidity release notes](https://github.com/ethereum/solidity/releases).

3. **Regular Updates**: Regularly update your contracts to use the latest stable compiler version, and thoroughly test them with the new version before deployment.

#### References:
- [SWC-103: Floating Pragma](https://swcregistry.io/docs/SWC-103)

By locking the pragma version and being aware of known bugs, you can enhance the reliability and security of your smart contracts.

