# Block values as a proxy for time

Contracts often need access to time values to perform certain types of functionality. Values such as `block.timestamp`, and `block.number` can give you a sense of the current time or a time delta, however, they are not safe to use for most purposes.

In the case of `block.timestamp`, developers often attempt to use it to trigger time-dependent events. As Ethereum is decentralized, nodes can synchronize time only to some degree. Moreover, malicious miners can alter the timestamp of their blocks, especially if they can gain advantages by doing so. However, miners can't set a timestamp smaller than the previous one (otherwise the block will be rejected), nor can they set the timestamp too far ahead in the future. Taking all of the above into consideration, developers can't rely on the preciseness of the provided timestamp.

As for `block.number`, considering the block time on Ethereum is generally about 14 seconds, it's possible to predict the time delta between blocks. However, block times are not constant and are subject to change for a variety of reasons, e.g. fork reorganisations and the difficulty bomb. Due to variable block times, `block.number` should also not be relied on for precise calculations of time.

## Remediation

Developers should write smart contracts with the notion that block values are not precise, and the use of them can lead to unexpected effects. Alternatively, they may make use of oracles.

## References

- [Safety: Timestamp dependence](https://github.com/ethereum/wiki/wiki/Safety#timestamp-dependence)
- [Ethereum Smart Contract Best Practices - Timestamp Dependence](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/timestamp-dependence/)
- [How do Ethereum mining nodes maintain a time consistent with the network?](https://ethereum.stackexchange.com/questions/5924/how-do-ethereum-mining-nodes-maintain-a-time-consistent-with-the-network/5926#5926)
- [Solidity: Timestamp dependency, is it possible to do safely?](https://ethereum.stackexchange.com/questions/15047/solidity-timestamp-dependency-is-it-possible-to-do-safely)
- [Avoid using block.number as a timestamp](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/timestamp-dependence/#avoid-using-blocknumber-as-a-timestamp)

## Samples

### time_lock.sol

```solidity
/*
 * @author: Kaden Zipfel
 */

pragma solidity ^0.5.0;

contract TimeLock {
    struct User {
        uint amount; // amount locked (in eth)
        uint unlockBlock; // minimum block to unlock eth
    }

    mapping(address => User) private users;

    // Tokens should be locked for exact time specified
    function lockEth(uint _time, uint _amount) public payable {
        require(msg.value == _amount, 'must send exact amount');
        users[msg.sender].unlockBlock = block.number + (_time / 14);
        users[msg.sender].amount = _amount;
    }

    // Withdraw tokens if lock period is over
    function withdraw() public {
        require(users[msg.sender].amount > 0, 'no amount locked');
        require(block.number >= users[msg.sender].unlockBlock, 'lock period not over');

        uint amount = users[msg.sender].amount;
        users[msg.sender].amount = 0;
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, 'transfer failed');
    }
}

```

### timed_crowdsale.sol

```solidity
pragma solidity ^0.5.0;

contract TimedCrowdsale {

  event Finished();
  event notFinished();

  // Sale should finish exactly at January 1, 2019
  function isSaleFinished() private returns (bool) {
    return block.timestamp >= 1546300800;
  }

  function run() public {
  	if (isSaleFinished()) {
  		emit Finished();
  	} else {
  		emit notFinished();
  	}
  }

}
```