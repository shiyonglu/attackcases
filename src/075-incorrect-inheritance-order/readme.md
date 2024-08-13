# Incorrect Inheritance Order in Solidity

Incorrect inheritance order in Solidity can lead to unexpected behavior and potential vulnerabilities, especially when dealing with multiple inheritance. Solidity uses a method called reverse C3 Linearization to resolve the order in which methods should be inherited when multiple inheritance is involved¹².

### The Diamond Problem

The Diamond Problem occurs when a contract inherits from multiple base contracts that define the same function. This creates ambiguity about which base contract's function should be called in the child contract. Solidity resolves this by establishing a hierarchy between base contracts using reverse C3 Linearization¹².

### Example

Consider the following example:

```solidity
pragma solidity ^0.8.0;

contract A {
    function foo() public pure returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure override returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure override returns (string memory) {
        return "C";
    }
}

contract D is B, C {
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}
```

In this example, contract `D` inherits from both `B` and `C`, which both override the `foo` function from `A`. The order of inheritance matters here because it determines which `foo` function is called. According to reverse C3 Linearization, `D` will inherit from `B` before `C`, so `D.foo()` will return "C"¹².

### Best Practices

To avoid issues related to incorrect inheritance order, follow these best practices:

1. **Specify Inheritance Order**: Clearly specify the order of inheritance in the contract definition.
2. **Use `virtual` and `override` Keywords**: Use the `virtual` keyword in base contracts and the `override` keyword in derived contracts to explicitly define which functions are being overridden.
3. **Review Inheritance Hierarchy**: Carefully review the inheritance hierarchy to ensure that the correct functions are being called.

By following these guidelines, you can minimize the risk of incorrect inheritance order and ensure that your smart contracts behave as expected.

If you have any further questions or need more examples, feel free to ask!

¹: [SolidityScan: Incorrect Inheritance Order](https://blog.solidityscan.com/incorrect-inheritance-order-in-smart-contracts-ddcc75ed472c)
²: [SWC Registry: Incorrect Inheritance Order](https://swcregistry.io/docs/SWC-125/)

Source: Conversation with Copilot, 8/13/2024
(1) Incorrect Inheritance Order in Smart Contracts | by Shashank | SolidityScan. https://blog.solidityscan.com/incorrect-inheritance-order-in-smart-contracts-ddcc75ed472c.
(2) SWC-125 - Smart Contract Weakness Classification (SWC). https://swcregistry.io/docs/SWC-125/.
(3) Understanding Inheritance in Solidity: A Comprehensive Guide. https://www.gyata.ai/solidity/solidity-inheritance.
(4) undefined. https://github.com/Arachnid/uscc/blob/master/submissions-2017/philipdaian/MDTCrowdsale.sol.
(5) undefined. https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol.
(6) undefined. https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522.
(7) undefined. https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol.
(8) undefined. https://github.com/ethereum/EIPs/issues/20.


### References
- [Consensys: Smart Contract Best Practices - Complex Inheritance](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/complex-inheritance/)
- [Solidity Documentation: Multiple Inheritance and Linearization](https://solidity.readthedocs.io/en/v0.4.25/contracts.html#multiple-inheritance-and-linearization)
- [Wikipedia: The Diamond Problem](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem)
- [Wikipedia: C3 Linearization](https://en.wikipedia.org/wiki/C3_linearization)