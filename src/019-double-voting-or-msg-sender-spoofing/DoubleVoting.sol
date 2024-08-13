import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.24;

contract SecureBallot {
    uint256 public proposal1VoteCount;
    uint256 public proposal2VoteCount;

    IERC20 private immutable governanceToken;

    // Mapping to track which tokens have been used to vote
    mapping(uint256 => bool) private tokenHasVoted;

    // Total number of tokens in circulation
    uint256 private totalTokens;

    constructor(IERC20 _governanceToken) {
        governanceToken = _governanceToken;
        totalTokens = governanceToken.totalSupply();
    }

    function voteFor1(uint256[] calldata tokenIds) external {
        _vote(tokenIds, 1);
    }

    function voteFor2(uint256[] calldata tokenIds) external {
        _vote(tokenIds, 2);
    }

    function _vote(uint256[] calldata tokenIds, uint256 proposal) internal {
        uint256 voteCount = 0;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(!tokenHasVoted[tokenIds[i]], "Token has already voted");

            tokenHasVoted[tokenIds[i]] = true;
            voteCount += 1; // Assuming each token represents 1 vote
        }

        if (proposal == 1) {
            proposal1VoteCount += voteCount;
        } else if (proposal == 2) {
            proposal2VoteCount += voteCount;
        } else {
            revert("Invalid proposal");
        }
    }
}
