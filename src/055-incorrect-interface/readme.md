# Incorrect Interface Vulnerability

#### Description:
An incorrect interface vulnerability occurs when a contract interface defines functions with a different type signature than the implementation. This discrepancy causes two different method IDs to be created. As a result, when the interface is called, the fallback method will be executed instead of the intended function.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

interface IExample {
    function foo(uint256 x) external;
}

contract Example {
    function foo(uint8 x) external {
        // Function logic here
    }
}
```

In this example, the interface `IExample` defines the function `foo` with a `uint256` parameter, while the `Example` contract implements `foo` with a `uint8` parameter. This mismatch in type signatures results in different method IDs being generated. When `IExample.foo` is called, the fallback function in `Example` will be executed instead of the intended `foo` function¹.

#### Prevention:
1. **Verify Type Signatures**: Ensure that the type signatures in the interface and the implementation match exactly. This includes parameter types and their order.
   ```solidity
   pragma solidity ^0.8.0;

   interface IExample {
       function foo(uint256 x) external;
   }

   contract Example is IExample {
       function foo(uint256 x) external override {
           // Function logic here
       }
   }
   ```

2. **Use the `override` Keyword**: When implementing an interface, use the `override` keyword to ensure that the function signatures match. The compiler will enforce this, preventing mismatches.
   ```solidity
   pragma solidity ^0.8.0;

   interface IExample {
       function foo(uint256 x) external;
   }

   contract Example is IExample {
       function foo(uint256 x) external override {
           // Function logic here
       }
   }
   ```

3. **Regular Audits and Reviews**: Conduct regular code reviews and security audits to identify and fix any discrepancies between interfaces and implementations.

By following these best practices, you can prevent incorrect interface vulnerabilities and ensure that your smart contracts function as intended.



¹: [Incorrect Interface - Not So Smart Contracts](https://github.com/crytic/not-so-smart-contracts/tree/master/incorrect_interface)

Source: Conversation with Copilot, 8/14/2024
(1) GitHub - crytic/not-so-smart-contracts: Examples of Solidity security .... https://github.com/crytic/not-so-smart-contracts.
(2) Solidity Smart Contract Vulnerabilities, Attack Scenarios, and .... https://link.springer.com/chapter/10.1007/978-981-99-3485-0_71.
(3) Most Common Vulnerabilities In Solidity: In-Depth Part 1. https://www.buildbear.io/resources/guides-and-tutorials/Common_Vulnerabilities_part_1.
(4) Solidity Hacks/Vulnerabilities how to fix it? - DEV Community. https://dev.to/fariztiger/solidity-hacks-vulnerabilities-how-to-fix-it-cam.
(5) Solidity by Example. https://solidity-by-example.org/hacks/re-entrancy/.
(6) Common Solidity Security Vulnerabilities & How to Avoid Them. https://metana.io/blog/common-solidity-security-vulnerabilities-how-to-avoid-them/.
(7) Common Vulnerabilities in Solidity and How to Address Them. https://www.soliditylibraries.com/tools/common-vulnerabilities-solidity-address/.
(8) Common Vulnerabilities in Solidity and How to Address Them. https://bing.com/search?q=how+to+prevent+solidity+Incorrect+interface+vulnerability.
(9) HackPedia: 16 Solidity Hacks/Vulnerabilities, their Fixes and Real .... https://hackernoon.com/hackpedia-16-solidity-hacks-vulnerabilities-their-fixes-and-real-world-examples-f3210eba5148.
(10) undefined. https://secure-contracts.com/%29.