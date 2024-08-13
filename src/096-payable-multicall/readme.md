# Payable Multicall

The Payable Multicall vulnerability arises when a contract uses the Multicall pattern and reads the value of `msg.value`. Multicall allows multiple contract endpoints to be called in a single transaction using `delegatecall`. However, this can lead to unintended behavior when `msg.value` is involved.

### How It Works

When a contract endpoint reads `msg.value`, it assumes that it is called in a single transaction. Since `msg.value` is defined per transaction, calling the same endpoint multiple times in one Multicall means that the same `msg.value` is read multiple times, even though the value was only transferred once.

### Example

Consider a token contract that accepts ETH in exchange for tokens in a swap function:

```solidity
pragma solidity ^0.8.0;

contract TokenSwap {
    uint256 public rate = 100; // 1 ETH = 100 tokens
    mapping(address => uint256) public balances;

    function swap() public payable {
        uint256 tokens = msg.value * rate;
        balances[msg.sender] += tokens;
    }
}
```

If this contract implements Multicall, an attacker can exploit it as follows:

1. The attacker sends 1 ETH in a Multicall transaction.
2. The attacker calls the `swap` function multiple times within the same transaction.
3. Each call to `swap` reads `msg.value` as 1 ETH and transfers 100 tokens to the attacker.
4. If the attacker calls `swap` 10 times, they receive 1,000 tokens in exchange for 1 ETH.

### Uniswap v3 Issue

Uniswap v3 encountered a similar issue where the Multicall pattern allowed attackers to exploit the `msg.value` in multiple calls within a single transaction. This led to unintended token transfers and potential losses.

### Prevention

To prevent this vulnerability, consider the following strategies:

1. **Avoid Reading `msg.value` in Multicall**: Ensure that functions reading `msg.value` are not called multiple times within a Multicall transaction.
2. **Track ETH Transfers**: Implement logic to track and limit the amount of ETH transferred in a single transaction.
3. **Use Nonce or Unique Identifiers**: Use nonces or unique identifiers to ensure that each call within a Multicall transaction is treated separately.

### Example Prevention

Here's an example of how to prevent this vulnerability:

```solidity
pragma solidity ^0.8.0;

contract TokenSwap {
    uint256 public rate = 100; // 1 ETH = 100 tokens
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastSwap;

    function swap() public payable {
        require(msg.value > 0, "No ETH sent");
        require(lastSwap[msg.sender] < block.number, "Already swapped in this block");

        uint256 tokens = msg.value * rate;
        balances[msg.sender] += tokens;
        lastSwap[msg.sender] = block.number;
    }
}
```

In this example, the `lastSwap` mapping ensures that each address can only call the `swap` function once per block, preventing multiple calls within a single Multicall transaction.

