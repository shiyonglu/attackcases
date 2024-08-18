# Off-By-One Error

The provided `ProportionalRewards` contract contains an off-by-one error that can lead to incorrect behavior. Let's break down the issue and how to prevent it.

### Example Scenario

Consider the following contract:

```solidity
contract ProportionalRewards {

    mapping(address => uint256) originalId;
    address[] stakers;

    function stake(uint256 id) public {
        nft.transferFrom(msg.sender, address(this), id);
        stakers.push(msg.sender);
    }

    function unstake(uint256 id) public {
        require(originalId[id] == msg.sender, "not the owner");

        removeFromArray(msg.sender, stakers);

        sendRewards(msg.sender, 
            totalRewardsSinceLastclaim() / stakers.length);

        nft.transferFrom(address(this), msg.sender, id);
    }
}
```

### Bug Explanation

The bug lies in the `unstake` function, specifically in the line:

```solidity
sendRewards(msg.sender, totalRewardsSinceLastclaim() / stakers.length);
```

After calling `removeFromArray(msg.sender, stakers)`, the length of the `stakers` array is reduced by one. If the `stakers` array initially had one element, its length becomes zero after removal. Dividing by zero will cause a runtime error, leading to a revert.

### Prevention

To prevent this off-by-one error, you should check if the `stakers` array is empty before performing the division. Here's an updated version of the contract with the necessary check:

```solidity
contract ProportionalRewards {

    mapping(address => uint256) originalId;
    address[] stakers;

    function stake(uint256 id) public {
        nft.transferFrom(msg.sender, address(this), id);
        stakers.push(msg.sender);
    }

    function unstake(uint256 id) public {
        require(originalId[id] == msg.sender, "not the owner");

        removeFromArray(msg.sender, stakers);

        uint256 stakerCount = stakers.length;
        require(stakerCount > 0, "No stakers available");

        sendRewards(msg.sender, totalRewardsSinceLastclaim() / stakerCount);

        nft.transferFrom(address(this), msg.sender, id);
    }
}
```

### Key Points to Remember

1. **Check Array Length**: Always check the length of arrays before performing operations that depend on their size, such as division.
2. **Handle Edge Cases**: Ensure your contract handles edge cases, such as empty arrays, to prevent runtime errors and unexpected behavior.
3. **Test Thoroughly**: Test your contracts thoroughly to identify and fix potential off-by-one errors and other bugs.

By implementing these preventive measures, you can avoid off-by-one errors and ensure the correct behavior of your smart contracts. If you have any more questions or need further assistance, feel free to ask!