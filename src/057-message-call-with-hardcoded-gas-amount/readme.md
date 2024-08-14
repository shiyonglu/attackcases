# Message Call with Hardcoded Gas Amount Vulnerability

#### Description:
The `transfer()` and `send()` functions in Solidity forward a fixed amount of 2300 gas. This was historically recommended to guard against reentrancy attacks. However, changes in the gas cost of EVM instructions during hard forks can break contracts that rely on fixed gas assumptions. For example, [EIP 1884](https://eips.ethereum.org/EIPS/eip-1884) increased the cost of the `SLOAD` instruction, breaking several existing contracts¹.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function sendEther(address payable recipient) public {
        recipient.transfer(1 ether);
    }
}
```

In this example, the `transfer` function forwards a fixed amount of 2300 gas. If the gas cost of EVM instructions changes, this function may fail.

#### Prevention:
1. **Avoid `transfer()` and `send()`**: Instead of using `transfer()` or `send()`, use `.call{value: ...}("")` to forward all available gas.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       function sendEther(address payable recipient) public {
           (bool success, ) = recipient.call{value: 1 ether}("");
           require(success, "Transfer failed.");
       }
   }
   ```

2. **Checks-Effects-Interactions Pattern**: Use this pattern to prevent reentrancy attacks. First, perform all checks, then update the state, and finally interact with external contracts.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       mapping(address => uint256) public balances;

       function withdraw(uint256 amount) public {
           require(balances[msg.sender] >= amount, "Insufficient balance");
           balances[msg.sender] -= amount;
           (bool success, ) = msg.sender.call{value: amount}("");
           require(success, "Transfer failed.");
       }
   }
   ```

3. **Reentrancy Locks**: Use reentrancy locks to prevent reentrant calls.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       bool private locked;

       modifier noReentrancy() {
           require(!locked, "No reentrancy");
           locked = true;
           _;
           locked = false;
       }

       function withdraw(uint256 amount) public noReentrancy {
           // Function logic here
       }
   }
   ```

By following these best practices, you can avoid the pitfalls of hardcoded gas amounts and ensure the robustness of your smart contracts.



¹: [SWC-134: Message Call with Hardcoded Gas Amount](https://swcregistry.io/docs/SWC-134)

Source: Conversation with Copilot, 8/14/2024
(1) GitHub - crytic/not-so-smart-contracts: Examples of Solidity security .... https://github.com/crytic/not-so-smart-contracts.
(2) Solidity Security: Comprehensive list of known attack vectors and .... https://blog.sigmaprime.io/solidity-security.html.
(3) HackPedia: 16 Solidity Hacks/Vulnerabilities, their Fixes and Real .... https://hackernoon.com/hackpedia-16-solidity-hacks-vulnerabilities-their-fixes-and-real-world-examples-f3210eba5148.
(4) Delegatecall Vulnerabilities In Solidity - Halborn. https://www.halborn.com/blog/post/delegatecall-vulnerabilities-in-solidity.
(5) Call - Solidity by Example. https://solidity-by-example.org/call/.
(6) Common Solidity Security Vulnerabilities & How to Avoid Them. https://metana.io/blog/common-solidity-security-vulnerabilities-how-to-avoid-them/.
(7) Common Vulnerabilities in Solidity and How to Address Them. https://www.soliditylibraries.com/tools/common-vulnerabilities-solidity-address/.
(8) undefined. https://secure-contracts.com/%29.