# Approval Vulnerabilities

### Approval Vulnerabilities in Smart Contracts

Approval vulnerabilities are a common issue in smart contracts, particularly those involving token transfers. These vulnerabilities arise when the `approve` function is used in a way that can be exploited by attackers. Let's explore this in detail.

### The Vulnerability

The `approve` function in ERC-20 tokens allows a token holder to authorize a spender to transfer tokens on their behalf. However, if not used carefully, this can lead to vulnerabilities such as the "race condition" or "double-spend" attack.

### Example

Consider the following scenario:

1. **Initial Approval**: Alice approves Bob to spend 100 tokens on her behalf.
2. **Race Condition**: Before Bob spends the tokens, Alice decides to change the approval to 50 tokens.
3. **Double-Spend Attack**: Bob observes the approval change and quickly spends the 100 tokens before the new approval of 50 tokens takes effect.

### Prevention

To prevent approval vulnerabilities, follow these best practices:

1. **Use `increaseAllowance` and `decreaseAllowance`**: Instead of directly setting the allowance, use functions that increment or decrement the allowance. This reduces the risk of race conditions.

   ```solidity
   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
       _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
       return true;
   }

   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
       _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
       return true;
   }
   ```

2. **Check Current Allowance**: Before changing the allowance, ensure that the current allowance is zero or explicitly set it to zero before updating it.

   ```solidity
   function approve(address spender, uint256 amount) public returns (bool) {
       require(_allowances[msg.sender][spender] == 0 || amount == 0, "Non-zero allowance");
       _approve(msg.sender, spender, amount);
       return true;
   }
   ```

3. **Use Safe Libraries**: Utilize well-audited libraries and frameworks that implement best practices for handling approvals.

### Example Prevention

Here's an example of a safer `approve` function:

```solidity
pragma solidity ^0.8.0;

contract SafeToken {
    mapping(address => mapping(address => uint256)) private _allowances;

    function approve(address spender, uint256 amount) public returns (bool) {
        require(_allowances[msg.sender][spender] == 0 || amount == 0, "Non-zero allowance");
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _allowances[msg.sender][spender] += addedValue;
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _allowances[msg.sender][spender] -= subtractedValue;
        return true;
    }
}
```

By following these guidelines, you can minimize the risk of approval vulnerabilities and ensure the security of your smart contracts.


### Reference
https://scsfg.io/hackers/approvals/
