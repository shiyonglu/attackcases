# Function Default Visibility Vulnerability

#### Description:
In Solidity, functions that do not have a specified visibility type are `public` by default. This can lead to vulnerabilities if a developer forgets to set the visibility, allowing malicious users to make unauthorized or unintended state changes.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function _sendWinnings() {
        // Function logic here
    }
}
```

In this example, the `_sendWinnings` function is intended to be private, but its visibility is not specified. As a result, it is `public` by default, allowing any external actor to call this function and potentially siphon the contract’s balance².

#### Real-World Example:
The Parity MultiSig Wallet hack is a notable example of this vulnerability. Two functions were left as `public`, allowing the attacker to change ownership and withdraw funds, resulting in a loss of about $31M worth of Ether².

#### Prevention:
1. **Always Specify Visibility**: Explicitly state the visibility of every function, even if it is intended to be public. For example:
   ```solidity
   function _sendWinnings() private {
       // Function logic here
   }
   ```

2. **Audits and Reviews**: Conduct multiple rounds of security audits, specifically focusing on function visibilities to ensure no functions are unintentionally left public.

3. **Compiler Warnings**: Pay attention to warnings provided by the Solidity compiler concerning function visibility and address them promptly.

4. **Access Control Patterns**: Implement access control mechanisms like `Ownable` to restrict access to sensitive functions.

By following these best practices, you can significantly reduce the attack surface of your contract system and prevent unauthorized access and manipulation.



²: [Solidity Security Vulnerability: Function Default Visibilities](https://www.immunebytes.com/blog/solidity-security-vulnerability-function-default-visibilities/)

Source: Conversation with Copilot, 8/14/2024
(1) Solidity Security Vulnerability: Function Default Visibilities. https://bing.com/search?q=solidity+Function+Default+Visibility+vulnerability+example.
(2) Solidity Security Vulnerability: Function Default Visibilities. https://www.immunebytes.com/blog/solidity-security-vulnerability-function-default-visibilities/.
(3) Solidity funcions visibility: public, private, internal and external. https://soliditytips.com/articles/solidity-function-visibility/.
(4) How to Manage Visibility of Variables and Functions in Solidity. https://www.developer.com/languages/variable-function-visibility-solidity/.
(5) Solidity Reentrance Vulnerability. https://www.youtube.com/watch?v=lH9mHiArjO8.
(6) Solidity Tutorial - Basics: Functions. https://www.youtube.com/watch?v=6g_3sSKiJpk.
(7) Techniques To Improve Vulnerability Visibility & Detection. https://www.youtube.com/watch?v=3K6TLqyxit4.
(8) Solidity Hacks/Vulnerabilities how to fix it? - DEV Community. https://dev.to/fariztiger/solidity-hacks-vulnerabilities-how-to-fix-it-cam.
(9) Common Solidity Security Vulnerabilities & How to Avoid Them. https://metana.io/blog/common-solidity-security-vulnerabilities-how-to-avoid-them/.
(10) undefined. https://www.derekarends.com/sunday-security-tip-reentrance-attack/.
(11) undefined. https://github.com/derekarends/solidity-vulnerabilities/tree/main/reentrance.
(12) undefined. https://purplesec.us/vulnerability-management-guide/.
(13) undefined. https://purplesec.us/learn/vulnerability-visibility.