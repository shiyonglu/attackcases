# Double Voting or `msg.sender` Spoofing Vulnerability in Solidity

**Double voting** or **`msg.sender` spoofing** occurs when an attacker uses vanilla ERC20 tokens or NFTs as tickets to weigh votes. The attacker can vote with one address, transfer the tokens to another address, and vote again from that address. This undermines the integrity of the voting process.

#### Example of Vulnerable Contract

Here's a minimal example of a vulnerable contract:

```solidity
// A malicious voter can simply transfer their tokens to
// another address and vote again.
contract UnsafeBallot {

    uint256 public proposal1VoteCount;
    uint256 public proposal2VoteCount;

    IERC20 immutable private governanceToken;

    constructor(IERC20 _governanceToken) {
        governanceToken = _governanceToken;
    }
	
    function voteFor1() external notAlreadyVoted {
        proposal1VoteCount += governanceToken.balanceOf(msg.sender);
    }

    function voteFor2() external notAlreadyVoted {
        proposal2VoteCount += governanceToken.balanceOf(msg.sender);
    }

    // prevent the same address from voting twice,
    // however the attacker can simply
    // transfer to a new address
    modifier notAlreadyVoted {
        require(!alreadyVoted[msg.sender], "already voted");
        _;
        alreadyVoted[msg.sender] = true;
    }
}
```

In this contract, the `notAlreadyVoted` modifier prevents the same address from voting twice. However, an attacker can transfer their tokens to a new address and vote again.

#### Prevention

To prevent this attack, you can use **ERC20 Snapshot** or **ERC20 Votes**. These mechanisms snapshot the token balances at a specific point in time, preventing manipulation of current token balances to gain illicit voting power.

##### Using ERC20 Snapshot

ERC20 Snapshot allows you to take a snapshot of the token balances at a specific block number. This ensures that the voting power is based on the balances at the time of the snapshot, not the current balances.

```solidity
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";

contract SafeBallot is ERC20Snapshot {

    uint256 public proposal1VoteCount;
    uint256 public proposal2VoteCount;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function voteFor1() external {
        uint256 balanceAtSnapshot = balanceOfAt(msg.sender, snapshotId);
        proposal1VoteCount += balanceAtSnapshot;
    }

    function voteFor2() external {
        uint256 balanceAtSnapshot = balanceOfAt(msg.sender, snapshotId);
        proposal2VoteCount += balanceAtSnapshot;
    }

    function snapshot() external {
        _snapshot();
    }
}
```

##### Using ERC20 Votes

ERC20 Votes is another approach that integrates voting mechanisms directly into the token contract. It ensures that voting power is based on the token balances at the time of the vote.

```solidity
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract SafeBallot is ERC20Votes {

    uint256 public proposal1VoteCount;
    uint256 public proposal2VoteCount;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function voteFor1() external {
        uint256 votes = getVotes(msg.sender);
        proposal1VoteCount += votes;
    }

    function voteFor2() external {
        uint256 votes = getVotes(msg.sender);
        proposal2VoteCount += votes;
    }
}
```

By using these mechanisms, you can ensure that the voting process is secure and resistant to double voting or `msg.sender` spoofing attacks.