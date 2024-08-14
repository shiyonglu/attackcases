# Requirement Violation Vulnerability

#### Description:
The Solidity `require()` construct is used to validate external inputs of a function. These inputs are typically provided by callers but can also be returned by callees. Violations of a requirement can indicate one of two issues:
1. A bug exists in the contract that provided the external input.
2. The condition used to express the requirement is too strong.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function transfer(address recipient, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        // Transfer logic here
    }
}
```

In this example, the `require` statement ensures that the `amount` is greater than zero. If an external input violates this condition, it could indicate a bug in the calling contract or that the condition is too strict¹.

#### Prevention:
1. **Weaken Strong Conditions**: If the required logical condition is too strong, it should be weakened to allow all valid external inputs. For example, if the condition `amount > 0` is too strict, consider adjusting it to a more appropriate condition.

2. **Fix Bugs in Calling Contracts**: If the violation is due to a bug in the calling contract, identify and fix the bug to ensure no invalid inputs are provided.

3. **Thorough Testing**: Conduct thorough testing to ensure that all possible inputs are valid and that the `require` conditions are appropriate.

4. **Code Reviews and Audits**: Regularly conduct code reviews and security audits to identify and fix potential requirement violations.

By following these best practices, you can prevent requirement violations and ensure the robustness of your smart contracts.



¹: [SWC-123: Requirement Violation](https://swcregistry.io/docs/SWC-123)

Source: Conversation with Copilot, 8/14/2024
(1) GitHub - crytic/not-so-smart-contracts: Examples of Solidity security .... https://github.com/crytic/not-so-smart-contracts.
(2) Solidity Security: Comprehensive list of known attack vectors and .... https://blog.sigmaprime.io/solidity-security.html.
(3) Security Considerations — Solidity 0.8.27 documentation. https://docs.soliditylang.org/en/latest/security-considerations.html.
(4) Common Solidity Security Vulnerabilities & How to Avoid Them. https://metana.io/blog/common-solidity-security-vulnerabilities-how-to-avoid-them/.
(5) Common Vulnerabilities in Solidity and How to Address Them. https://www.soliditylibraries.com/tools/common-vulnerabilities-solidity-address/.
(6) Solidity Re-Entrancy Prevention: How to Secure Your Contract. https://www.infuy.com/blog/preventing-re-entrancy-attacks-in-solidity/.
(7) undefined. https://secure-contracts.com/%29.