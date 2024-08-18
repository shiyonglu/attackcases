# Transfer() and send() can break with multi-signature wallets

Let's dive into the details of the vulnerability related to `transfer()` and `send()` in Solidity, especially in the context of multi-signature wallets like Gnosis Safe.

### Vulnerability Overview

The Solidity functions `transfer()` and `send()` are designed to send Ether to an address, but they limit the amount of gas forwarded with the transaction to 2,300 gas. This is done as a security measure to prevent reentrancy attacks. However, this limitation can cause issues when interacting with contracts that require more gas to execute their fallback functions.

### Example Scenario

Consider a multi-signature wallet like Gnosis Safe, which has a fallback function that forwards calls to another address. The fallback function might look something like this:

```solidity
fallback() external {
    bytes32 slot = FALLBACK_HANDLER_STORAGE_SLOT;
    assembly {
        let handler := sload(slot)
        if iszero(handler) {
            return(0, 0)
        }
        calldatacopy(0, 0, calldatasize())
        mstore(calldatasize(), shl(96, caller()))
        let success := call(gas(), handler, 0, 0, add(calldatasize(), 20), 0, 0)
        returndatacopy(0, 0, returndatasize())
        if iszero(success) {
            revert(0, returndatasize())
        }
        return(0, returndatasize())
    }
}
```

If someone uses `transfer()` or `send()` to send Ether to this multi-signature wallet, the fallback function could run out of gas because the 2,300 gas limit is insufficient for the operations it needs to perform. As a result, the transfer would fail.

### Prevention

To avoid this issue, it's recommended to use the `call` method instead of `transfer()` or `send()`. The `call` method allows you to specify the amount of gas to forward with the transaction, thus avoiding the gas limit issue. Here's an example of how to use `call`:

```solidity
(bool success, ) = recipient.call{value: amount}("");
require(success, "Transfer failed");
```

### Key Points to Remember

1. **Avoid `transfer()` and `send()`**: These functions limit the gas forwarded to 2,300, which can cause transactions to fail if the recipient contract requires more gas.
2. **Use `call` instead**: The `call` method allows you to specify the gas limit, making it more flexible and suitable for interacting with complex contracts.
3. **Test thoroughly**: Always test your contracts thoroughly to ensure they handle Ether transfers correctly, especially when interacting with multi-signature wallets or other complex contracts.

By following these guidelines, you can prevent issues related to gas limits and ensure smooth interactions with multi-signature wallets and other contracts. If you need more information on reducing gas costs, you can refer to the [Ethereum access list transactions article](https://www.rareskills.io/post/eip-2930-optional-access-list-ethereum).

Feel free to ask if you have any more questions or need further clarification!