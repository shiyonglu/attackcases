# Solidity Signature Malleability Vulnerability

**Signature malleability** is a vulnerability where an attacker can modify a valid signature to create a different one that is still valid. This can lead to replay attacks, where the modified signature can be used to bypass signature checks.

#### Example Code

Here's an example demonstrating how a valid signature can be modified to create a new valid signature:

```solidity
contract Malleable {

    // v = 28
    // r = 0xf8479d94c011613baeffe9239e4ff65e2adbac744c34217ca7d51378e72c5204
    // s = 0x57af17590a914b759c45aaeabaf513d5ef72d7da1bdd19d9f2e1bc371ece5b86
    // m = 0x0000000000000000000000000000000000000000000000000000000000000003
    function foo(bytes calldata msg, uint8 v, bytes32 r, bytes32 s) public pure returns (address, address){
        bytes32 h = keccak256(msg);
        address a = ecrecover(h, v, r, s);

        // The following is math magic to invert the 
        // signature and create a valid one
        // flip s
        bytes32 s2 = bytes32(uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141) - uint256(s));

        // invert v
        uint8 v2;
        require(v == 27 || v == 28, "invalid v");
        v2 = v == 27 ? 28 : 27;

        address b = ecrecover(h, v2, r, s2);

        assert(a == b); 
        // different signatures, same address!;
        return (a, b);
    }
}
```

In this example, the function `foo` takes a message, a signature `(v, r, s)`, and performs some arithmetic to create a new valid signature `(v2, r, s2)`. The new signature still passes the `ecrecover` check, demonstrating the malleability.

#### Vulnerable Contract

Here's an example of a vulnerable contract:

```solidity
contract InsecureContract {

    address signer;

    function airdrop(address who, uint256 amount, uint8 v, bytes32 r, bytes32 s) external {

        address recovered = ecrecover(keccak256(abi.encode(who, amount)), v, r, s);
        require(recovered != address(0), "invalid signature");
        require(recovered == signer, "recovered signature not equal signer");

        bytes memory signature = abi.encodePacked(v, r, s);
        require(!used[signature], "signature already used"); // this can be bypassed
        used[signature] = true;

        mint(msg.sender, amount);
    }
}
```

In this contract, the `airdrop` function checks if a signature has been used before. However, due to signature malleability, an attacker can modify a valid signature and bypass the `used` check.

### Prevention

To prevent signature malleability, you can use the following techniques:

1. **Enforce Lower `s` Value**: Ensure that the `s` value of the signature is in the lower half of the curve. This can be done by checking if `s` is less than or equal to `0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0`.

```solidity
require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "invalid s value");
```

2. **Use EIP-2**: Follow the Ethereum Improvement Proposal (EIP) 2, which enforces the lower `s` value and standardizes the `v` value to be either 27 or 28.

3. **Hash the Signature**: Instead of storing the raw signature, store a hash of the signature. This way, even if the signature is modified, the hash will not match.

```solidity
bytes32 signatureHash = keccak256(abi.encodePacked(v, r, s));
require(!used[signatureHash], "signature already used");
used[signatureHash] = true;
```

By implementing these techniques, you can mitigate the risk of signature malleability and ensure the security of your smart contracts.

