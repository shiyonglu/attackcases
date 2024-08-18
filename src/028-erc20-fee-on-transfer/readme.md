### ERC20: Fee on Transfer Vulnerability in Solidity

When dealing with untrusted ERC20 tokens, you shouldn't assume that your balance necessarily increases by the amount transferred. Some ERC20 tokens implement a fee on transfer, which can lead to unexpected behavior and potential vulnerabilities.

#### Example of Vulnerable Code

Here's an example of an ERC20 token that applies a 1% tax to every transaction:

```solidity
contract ERC20 {

    // internally called by transfer() and transferFrom()
    // balance and approval checks happen in the caller
    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        uint256 fee = amount * 100 / 99;

        balanceOf[from] -= amount;
        balanceOf[to] += (amount - fee);

        balanceOf[TREASURY] += fee;

        emit Transfer(from, to, (amount - fee));
        return true;
    }
}
```

In this code, the `_transfer` function deducts a 1% fee from the transferred amount and sends it to a treasury address. This means that the recipient receives only 99% of the transferred amount.

#### Example of Vulnerable Contract Interacting with Fee-on-Transfer Token

Here's an example of a vulnerable contract that interacts with the fee-on-transfer token:

```solidity
contract Stake {

    mapping(address => uint256) public balancesInContract;
    IERC20 public token;

    function stake(uint256 amount) public {
        token.transferFrom(msg.sender, address(this), amount);

        balancesInContract[msg.sender] += amount; // THIS IS WRONG!
    }

    function unstake() public {
        uint256 toSend = balancesInContract[msg.sender];
        delete balancesInContract[msg.sender];

        // this could revert because toSend is 1% greater than
        // the amount in the contract. Otherwise, 1% will be "stolen"
        // from other depositors.
        token.transfer(msg.sender, toSend);
    }
}
```

In this contract, the `stake` function assumes that the full `amount` is transferred to the contract, but due to the 1% fee, only 99% of the amount is actually received. This leads to incorrect accounting and potential reverts or stolen funds during the `unstake` function.

#### Prevention

To prevent this issue, you should account for the fee when interacting with fee-on-transfer tokens. Here's an improved version of the contract:

```solidity
contract SafeStake {

    mapping(address => uint256) public balancesInContract;
    IERC20 public token;

    function stake(uint256 amount) public {
        uint256 balanceBefore = token.balanceOf(address(this));
        token.transferFrom(msg.sender, address(this), amount);
        uint256 balanceAfter = token.balanceOf(address(this));

        uint256 receivedAmount = balanceAfter - balanceBefore;
        balancesInContract[msg.sender] += receivedAmount;
    }

    function unstake() public {
        uint256 toSend = balancesInContract[msg.sender];
        delete balancesInContract[msg.sender];

        token.transfer(msg.sender, toSend);
    }
}
```

In this improved version, the `stake` function calculates the actual amount received by comparing the contract's balance before and after the transfer. This ensures that the correct amount is accounted for, preventing unexpected reverts and stolen funds.

#### Key Takeaways

- **Account for Fees**: When dealing with fee-on-transfer tokens, always account for the fee to ensure correct accounting.
- **Check Balances**: Use balance checks before and after transfers to determine the actual amount received.

By following these practices, you can avoid issues related to fee-on-transfer tokens in Solidity and ensure that your smart contracts behave as expected.