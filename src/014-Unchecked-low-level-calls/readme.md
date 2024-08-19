### Unchecked Return Values for Low-Level Calls

#### Overview

Unchecked return values for low-level calls in Solidity, such as `call()`, `callcode()`, `delegatecall()`, and `send()`, are a source of significant vulnerability. These functions do not propagate errors or revert the execution of the contract when they fail. Instead, they return a boolean value (`true` for success, `false` for failure). If the return value is not properly checked, the contract can continue execution under incorrect assumptions, potentially leading to security issues, including loss of funds or inconsistent state.

#### Real-World Impact

1. **King of the Ether**: This was a smart contract game where the failure to check the return value of `send()` led to unexpected behavior when sending Ether failed, allowing an unintended participant to become the "King" by default.
2. **Etherpot**: This smart contract suffered from issues related to using the blockhash opcode incorrectly, which, while not directly related to unchecked return values, highlights how subtle smart contract bugs can lead to significant losses.

#### Vulnerability Example

Consider a simple `withdraw()` function that allows users to withdraw funds from the contract. If the contract does not check the return value of `send()`, it risks having incorrect state if the send operation fails.

##### Vulnerable Code Example:
```solidity
function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    etherLeft -= _amount;
    msg.sender.send(_amount); // Unchecked return value
}
```

**Exploit Scenario**:
- **Initial Condition**: A user has a balance of 5 ETH in the contract.
- **Attack**: The user tries to withdraw 3 ETH.
- **Potential Issue**: If the `send()` fails (for example, because the receiving contract does not have a payable fallback function), the `send()` will return `false`.
- **Result**: The balance and `etherLeft` will still be updated even though the `send()` failed, leading to an incorrect state where the contract believes the Ether was successfully sent.

#### Prevention

1. **Check the Return Value of Low-Level Calls**:
   - Always check the return value of low-level calls like `send()`, `call()`, `delegatecall()`, and `callcode()`. If the return value is `false`, handle the failure appropriately, such as reverting the transaction or taking corrective action.

   ##### Example with Return Value Check:
   ```solidity
   function withdraw(uint256 _amount) public {
       require(balances[msg.sender] >= _amount);
       balances[msg.sender] -= _amount;
       etherLeft -= _amount;
       bool success = msg.sender.send(_amount);
       require(success, "Transfer failed.");
   }
   ```

2. **Use Higher-Level Functions**:
   - Whenever possible, use higher-level functions like `transfer()` instead of `send()` or `call()`. The `transfer()` function automatically reverts the transaction if the send fails, providing built-in safety against unchecked return values.

   ##### Example with `transfer()`:
   ```solidity
   function withdraw(uint256 _amount) public {
       require(balances[msg.sender] >= _amount);
       balances[msg.sender] -= _amount;
       etherLeft -= _amount;
       msg.sender.transfer(_amount); // Automatically reverts on failure
   }
   ```

3. **Use SafeMath and Other Libraries**:
   - Combine return value checks with SafeMath operations to ensure that arithmetic operations are secure and the contract state remains consistent.

4. **Be Aware of the Gas Limit**:
   - Understand the gas implications of `send()` and `call()`. These low-level functions forward a limited amount of gas, which might cause them to fail if the recipient contract requires more gas to execute.






**Additional Resources**:

*   [Unchecked external call](https://github.com/trailofbits/not-so-smart-contracts/tree/master/unchecked_external_call)
*   [Scanning Live Ethereum Contracts for the "Unchecked-Send" Bug](http://hackingdistributed.com/2016/06/16/scanning-live-ethereum-contracts-for-bugs/)
