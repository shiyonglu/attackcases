# Treating Cryptographic Proofs Like Passwords Vulnerability in Solidity

**Treating cryptographic proofs like passwords** is a common misunderstanding among developers about how to use cryptography to give addresses special privileges. This can lead to significant security vulnerabilities.

#### Example of Vulnerable Contract

Here's an example of a vulnerable contract:

```solidity
contract InsecureMerkleRoot {
    bytes32 merkleRoot;
    mapping(bytes32 => bool) alreadyClaimed;

    function airdrop(bytes[] calldata proof, bytes32 leaf) external {
        require(MerkleProof.verifyCalldata(proof, merkleRoot, leaf), "not verified");
        require(!alreadyClaimed[leaf], "already claimed airdrop");
        alreadyClaimed[leaf] = true;

        mint(msg.sender, AIRDROP_AMOUNT);
    }
}
```

This code is insecure for three reasons:

1. **Recreating the Merkle Tree**: Anyone who knows the addresses selected for the airdrop can recreate the Merkle tree and create a valid proof.
2. **Unhashed Leaf**: The leaf isn't hashed. An attacker can submit a leaf that equals the Merkle root and bypass the `require` statement.
3. **Front-Running**: Even if the above two issues are fixed, once someone submits a valid proof, they can be front-run.

#### Prevention

To prevent these vulnerabilities, cryptographic proofs (Merkle trees, signatures, etc.) need to be tied to `msg.sender`, which an attacker cannot manipulate without acquiring the private key.

#### Example of Improved Contract

Here's an improved version of the contract that addresses these issues:

```solidity
contract SecureMerkleRoot {
    bytes32 merkleRoot;
    mapping(bytes32 => bool) alreadyClaimed;

    function airdrop(bytes[] calldata proof, bytes32 leaf) external {
        // Hash the leaf with msg.sender to tie the proof to the sender
        bytes32 hashedLeaf = keccak256(abi.encodePacked(msg.sender, leaf));
        
        require(MerkleProof.verifyCalldata(proof, merkleRoot, hashedLeaf), "not verified");
        require(!alreadyClaimed[hashedLeaf], "already claimed airdrop");
        alreadyClaimed[hashedLeaf] = true;

        mint(msg.sender, AIRDROP_AMOUNT);
    }
}
```

In this improved version:

1. **Hashing the Leaf**: The leaf is hashed with `msg.sender` to tie the proof to the sender. This prevents attackers from recreating the Merkle tree and creating a valid proof.
2. **Preventing Front-Running**: By tying the proof to `msg.sender`, front-running attacks are mitigated because the proof is unique to the sender.

By understanding and addressing these vulnerabilities, you can enhance the security of your smart contracts and ensure that cryptographic proofs are used correctly.