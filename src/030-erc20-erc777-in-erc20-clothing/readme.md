# ERC20: ERC777 in ERC20 Clothing Vulnerability in Solidity

ERC20 tokens, if implemented according to the standard, do not have transfer hooks, and thus `transfer` and `transferFrom` functions do not have a reentrancy issue. However, ERC777 tokens, which include transfer hooks, can introduce reentrancy vulnerabilities if not handled properly.

#### Example of Vulnerable Code

Here's an example of a contract that interacts with an ERC20 token, assuming it does not have transfer hooks:

```solidity
contract SafeERC20Interaction {
    IERC20 public token;

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        // Additional logic
    }

    function withdraw(uint256 amount) external {
        token.transfer(msg.sender, amount);
        // Additional logic
    }
}
```

In this code, the `deposit` and `withdraw` functions assume that the `transfer` and `transferFrom` functions do not have reentrancy issues. However, if the token is actually an ERC777 token in ERC20 clothing, it could introduce reentrancy vulnerabilities.

#### Prevention

To prevent this issue, you should treat the `transfer` and `transferFrom` functions as if they will issue a function call to the receiver. This means implementing reentrancy guards to protect against potential reentrancy attacks.

#### Example of Improved Code

Here's an improved version of the contract that includes reentrancy guards:

```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SafeERC777Interaction is ReentrancyGuard {
    IERC20 public token;

    function deposit(uint256 amount) external nonReentrant {
        token.transferFrom(msg.sender, address(this), amount);
        // Additional logic
    }

    function withdraw(uint256 amount) external nonReentrant {
        token.transfer(msg.sender, amount);
        // Additional logic
    }
}
```

In this improved version, the `deposit` and `withdraw` functions are protected by the `nonReentrant` modifier from the `ReentrancyGuard` contract. This ensures that reentrancy attacks are prevented, even if the token has transfer hooks.

#### Key Takeaways

- **Treat Transfer Functions with Caution**: When dealing with tokens that may have transfer hooks, treat the `transfer` and `transferFrom` functions as if they will issue a function call to the receiver.
- **Use Reentrancy Guards**: Implement reentrancy guards to protect against potential reentrancy attacks.

By following these practices, you can avoid issues related to ERC777 tokens in ERC20 clothing and ensure that your smart contracts behave as expected.