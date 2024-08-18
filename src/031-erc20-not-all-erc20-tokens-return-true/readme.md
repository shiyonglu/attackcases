# ERC20: Not All ERC20 Tokens Return True Vulnerability in Solidity

The ERC20 specification dictates that an ERC20 token must return `true` when a transfer succeeds. However, not all ERC20 tokens follow this protocol, which can lead to unexpected behavior and potential vulnerabilities when interacting with arbitrary ERC20 tokens.

#### Example of Vulnerable Code

Here's an example of a contract that assumes all ERC20 tokens return `true` on successful transfers:

```solidity
contract AssumesTrue {
    IERC20 public token;

    function transferTokens(address to, uint256 amount) external {
        // Assumes the transfer will return true
        require(token.transfer(to, amount), "Transfer failed");
    }
}
```

In this code, the `transferTokens` function assumes that the `transfer` function will return `true` on success. However, some ERC20 tokens, notably Tether (USDT), do not follow this protocol and may return `false` or revert on failure.

#### Prevention

To prevent this issue, you can use libraries that handle the variance in behavior of ERC20 tokens. OpenZeppelin's `SafeERC20` and Solady's `SafeTransferLib` are two such libraries that provide safe transfer functions.

#### Example of Improved Code

Here's an improved version of the contract that uses OpenZeppelin's `SafeERC20` library:

```solidity
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SafeTransfer {
    using SafeERC20 for IERC20;
    IERC20 public token;

    function transferTokens(address to, uint256 amount) external {
        token.safeTransfer(to, amount);
    }
}
```

In this improved version, the `safeTransfer` function from the `SafeERC20` library is used to handle the transfer. This function ensures that the transfer is successful and reverts if it fails, providing a consistent behavior across different ERC20 tokens.

#### Key Takeaways

- **Account for Variance in ERC20 Tokens**: When dealing with arbitrary ERC20 tokens, account for the possibility that not all tokens return `true` on successful transfers.
- **Use Safe Transfer Libraries**: Use libraries like OpenZeppelin's `SafeERC20` or Solady's `SafeTransferLib` to handle the variance in behavior and ensure safe transfers.

By following these practices, you can avoid issues related to ERC20 tokens that do not return `true` on successful transfers and ensure that your smart contracts behave as expected.