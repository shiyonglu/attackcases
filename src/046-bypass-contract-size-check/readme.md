# Bypass Contract Size Check Vulnerability

The "Bypass Contract Size Check" vulnerability arises from the fact that during the construction phase of a contract, the `extcodesize` of the contract is zero. This can be exploited to bypass checks that rely on `extcodesize` to determine if an address is a contract. Let's explore this in detail with an example and prevention strategies.

### How It Works

The `extcodesize` opcode returns the size of the code at a given address. If the size is greater than zero, the address is a contract; otherwise, it is an Externally Owned Account (EOA) or an address with no code. During the construction phase of a contract, the `extcodesize` of the contract is zero, which can be exploited to bypass checks.

### Example

Consider the following vulnerable contract:

```solidity
pragma solidity ^0.8.0;

contract Target {
    function isContract(address account) public view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    bool public pwned = false;

    function protected() external {
        require(!isContract(msg.sender), "No contract allowed");
        pwned = true;
    }
}
```

In this example, the `protected` function checks if the caller is a contract using the `isContract` function. If the caller is a contract, the function reverts. However, this check can be bypassed during the construction phase of a contract.

Here's how an attacker can exploit this vulnerability:

```solidity
pragma solidity ^0.8.0;

contract Hack {
    constructor(address target) {
        Target(target).protected();
    }
}
```

In this example, the `Hack` contract calls the `protected` function of the `Target` contract during its construction phase. Since the `extcodesize` of the `Hack` contract is zero during construction, the `isContract` check in the `Target` contract will return false, allowing the call to succeed.

### Prevention

To prevent this vulnerability, consider the following strategies:

1. **Avoid Relying Solely on `extcodesize`**: Do not rely solely on `extcodesize` to determine if an address is a contract. Instead, use other mechanisms to verify the caller's identity.

2. **Use a Whitelist**: Implement a whitelist of allowed addresses to ensure that only authorized addresses can call certain functions.

   ```solidity
   mapping(address => bool) public whitelist;

   function addToWhitelist(address account) public onlyOwner {
       whitelist[account] = true;
   }

   function protected() external {
       require(whitelist[msg.sender], "Not whitelisted");
       pwned = true;
   }
   ```

3. **Use Nonces or Unique Identifiers**: Use nonces or unique identifiers to ensure that each call is unique and cannot be replayed during the construction phase.

By following these guidelines, you can minimize the risk of bypassing contract size checks and ensure the security and reliability of your smart contracts.

If you have any further questions or need more examples, feel free to ask!

Source: Conversation with Copilot, 8/13/2024
(1) Bypass Contract Size Check - Solidity by Example. https://solidity-by-example.org/hacks/contract-size/.
(2) Crypto Market Pool - Bypass Solidity contract size check. https://bing.com/search?q=Bypass+Contract+Size+Check+in+Solidity.
(3) Crypto Market Pool - Bypass Solidity contract size check. https://cryptomarketpool.com/bypass-solidity-contract-size-check/.
(4) How to check the size of a contract in Solidity?. https://ethereum.stackexchange.com/questions/31515/how-to-check-the-size-of-a-contract-in-solidity.