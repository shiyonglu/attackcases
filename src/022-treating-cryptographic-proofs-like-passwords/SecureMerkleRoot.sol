// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract SecureMerkleRoot {
    bytes32 public merkleRoot;
    mapping(bytes32 => bool) public alreadyClaimed;
    uint256 public constant AIRDROP_AMOUNT = 1000;

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
    }

    function airdrop(bytes32[] calldata proof) external {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "not verified");
        require(!alreadyClaimed[leaf], "already claimed airdrop");

        alreadyClaimed[leaf] = true;
        _mint(msg.sender, AIRDROP_AMOUNT);
    }

    function _mint(address to, uint256 amount) internal {
        // Implement your token minting logic here
    }
}
