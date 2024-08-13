# Treating Cryptographic Proofs Like Passwords
The SecureMerkleRoot smart contract aims to address common vulnerabilities found in cryptographic proof implementations, such as Merkle trees. The contract secures the airdrop mechanism by ensuring that only valid addresses can claim their airdrops while mitigating common attack vectors.

# Description
The contract verifies Merkle proofs to allow eligible addresses to claim airdrops. It addresses the following vulnerabilities present in insecure implementations:

# Prevents attackers from recreating the Merkle tree and generating valid proofs.
Hashes the leaf to ensure security.
Ties the proof to the msg.sender to prevent front-running attacks.
Functions
airdrop(): Allows eligible addresses to claim their airdrop by providing a valid Merkle proof. It verifies the proof, checks if the airdrop has already been claimed, and then mints tokens to the caller.
Usage
Deploy the SecureMerkleRoot contract with the appropriate Merkle root.
Call the airdrop function with the correct proof and leaf to claim the airdrop.