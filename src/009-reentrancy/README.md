### Solidity Re-Entrancy Vulnerability

#### Overview

Re-entrancy is a well-known vulnerability in Ethereum smart contracts, famously exploited during "The DAO" hack in 2016. It occurs when a contract makes an external call to another untrusted contract, and that external contract makes a recursive call back into the original contract before the initial function execution is completed. This can allow the attacker to manipulate the contract’s state in unexpected ways, such as withdrawing funds multiple times.

This vulnerability is also referred to as **race to empty**, **recursive call vulnerability**, or **call to the unknown**. It often escapes detection during code reviews because reviewers typically assess functions in isolation, assuming that secure subroutines will operate as intended.

#### Example

Consider a smart contract that tracks user balances and provides a `withdraw()` function allowing users to withdraw their funds. Here’s a simplified version of the vulnerable code:

```solidity
mapping(address => uint256) public balances;

function deposit() public payable {
    balances[msg.sender] += msg.value;
}

function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    (bool success, ) = msg.sender.call{value: _amount}(""); // Send Ether
    require(success, "Transfer failed");
    balances[msg.sender] -= _amount;
}
```

1. **Deposit Functionality**: Users can deposit Ether into the contract, which is recorded in a `balances` mapping.
2. **Withdraw Functionality**: Users can withdraw their Ether by calling the `withdraw()` function.

##### Attack Scenario:

1. **Initial Call**: An attacker deposits some Ether into the contract and calls the `withdraw()` function to withdraw it.
2. **Re-Entrancy Attack**: 
   - The contract sends the Ether to the attacker’s contract using `call{value: _amount}("")`, triggering the attacker's contract’s `fallback()` function.
   - In the `fallback()` function, the attacker’s contract recursively calls the `withdraw()` function again before the original contract updates the balance.
3. **Result**: The attacker can repeatedly withdraw funds, as the balance is not updated before each subsequent withdrawal.

##### Code Example of Attacker Contract:

```solidity
contract Attacker {
    Victim victim;

    constructor(address _victimAddress) {
        victim = Victim(_victimAddress);
    }

    function attack() external payable {
        victim.deposit{value: msg.value}();
        victim.withdraw(msg.value);
    }

    receive() external payable {
        if (address(victim).balance >= msg.value) {
            victim.withdraw(msg.value);
        }
    }
}
```

In this attack:
- The attacker deposits Ether into the victim contract.
- The attacker initiates a `withdraw()` call, triggering the `receive()` fallback function in the attacker contract when Ether is sent back.
- The fallback function recursively calls `withdraw()` again, allowing the attacker to drain funds.

#### Prevention

**1. **Update State Before External Calls**:
   - Always update the contract’s state before making an external call to an untrusted contract. This prevents the state from being manipulated during the execution of the external call.

```solidity
function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    balances[msg.sender] -= _amount;
    (bool success, ) = msg.sender.call{value: _amount}("");
    require(success, "Transfer failed");
}
```

**2. **Use Mutex Locks**:
   - Implement a re-entrancy guard using a mutex lock to ensure that no function can be called recursively.

```solidity
bool internal locked;

modifier noReentrant() {
    require(!locked, "Reentrant call");
    locked = true;
    _;
    locked = false;
}

function withdraw(uint256 _amount) public noReentrant {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    (bool success, ) = msg.sender.call{value: _amount}("");
    require(success, "Transfer failed");
    balances[msg.sender] -= _amount;
}
```

**3. **Use `send` or `transfer` Instead of `call`**:
   - Use `send` or `transfer` functions instead of `call`. These functions only forward a limited amount of gas, preventing the execution of further code, which mitigates re-entrancy attacks. However, be aware that `send` and `transfer` may break if gas costs increase.

```solidity
function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    msg.sender.transfer(_amount);
    balances[msg.sender] -= _amount;
}
```

**4. **Use Checks-Effects-Interactions Pattern**:
   - Follow the checks-effects-interactions pattern, where state changes (effects) are made before any external calls (interactions).

```solidity
function withdraw(uint256 _amount) public {
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    uint256 balance = balances[msg.sender];
    balances[msg.sender] -= _amount;
    msg.sender.transfer(_amount);
}
```




**Additional Resources**:

*   [The DAO smart contract](https://etherscan.io/address/0xbb9bc244d798123fde783fcc1c72d3bb8c189413#code)
*   [Analysis of the DAO exploit](http://hackingdistributed.com/2016/06/18/analysis-of-the-dao-exploit/)
*   [Simple DAO code example](http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao)
*   [Reentrancy code example](https://github.com/trailofbits/not-so-smart-contracts/tree/master/reentrancy)
*   [How Someone Tried to Exploit a Flaw in Our Smart Contract and Steal All of Its Ether](https://blog.citymayor.co/posts/how-someone-tried-to-exploit-a-flaw-in-our-smart-contract-and-steal-all-of-its-ether/)
