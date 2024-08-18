### Solidity Signature Forgery Vulnerability

**Signatures can be forged or crafted without proper safeguards** if the hashing is not done on-chain. This vulnerability allows an attacker to reuse a valid signature and hash from another message, leading to potential exploits.

#### Example Code

Here's an example demonstrating a vulnerable function for recovering signatures:

```solidity
// this code is vulnerable!
function recoverSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public returns (address signer) {
    require(signer == ecrecover(hash, v, r, s), "signer does not match");
    // more actions
}
```

In this example, the user supplies both the hash and the signatures. If an attacker has already seen a valid signature from the signer, they can reuse the hash and signature of another message.

#### Vulnerability Explanation

The vulnerability arises because the hashing is not done on-chain. An attacker can exploit this by reusing a valid signature and hash from another message, effectively forging the signature.

### Prevention

To prevent this vulnerability, you should always hash the message in the smart contract. This ensures that the hash is unique to the specific message and cannot be reused by an attacker.

1. **Hash the Message On-Chain**: Always hash the message within the smart contract to ensure its integrity.

```solidity
function recoverSigner(address who, uint256 amount, uint8 v, bytes32 r, bytes32 s) public returns (address signer) {
    bytes32 hash = keccak256(abi.encodePacked(who, amount));
    require(signer == ecrecover(hash, v, r, s), "signer does not match");
    // more actions
}
```

2. **Use Nonces**: Incorporate nonces in the message to ensure that each message has a unique hash.

```solidity
function recoverSigner(address who, uint256 amount, uint256 nonce, uint8 v, bytes32 r, bytes32 s) public returns (address signer) {
    bytes32 hash = keccak256(abi.encodePacked(who, amount, nonce));
    require(signer == ecrecover(hash, v, r, s), "signer does not match");
    // more actions
}
```

3. **Timestamping**: Include timestamps in the message to ensure that the hash is unique to a specific time.

```solidity
function recoverSigner(address who, uint256 amount, uint256 timestamp, uint8 v, bytes32 r, bytes32 s) public returns (address signer) {
    bytes32 hash = keccak256(abi.encodePacked(who, amount, timestamp));
    require(signer == ecrecover(hash, v, r, s), "signer does not match");
    // more actions
}
```

By implementing these techniques, you can mitigate the risk of signature forgery and ensure the security of your smart contracts.


### Unsafe Example

```solidity
signer == bytes32(data).recover(signature);
```

In this example, the data is not hashed in a way that ensures its integrity and uniqueness. This can lead to vulnerabilities where an attacker can reuse a valid signature and hash from another message.

### Safe Example

```solidity
signer == data.toEthSignedMessageHash().recover(signature);
```

In this example, the `toEthSignedMessageHash()` function is used to hash the data in a way that is compatible with Ethereum's signature scheme. This ensures that the hash is unique to the specific message and cannot be reused by an attacker.

The `toEthSignedMessageHash()` function adds a prefix to the data before hashing it, which helps prevent signature forgery. This is a recommended practice to ensure the security of your smart contracts.

