# Hash Collisions With Multiple Variable Length Arguments

#### Description:
Using `abi.encodePacked()` with multiple variable length arguments can lead to hash collisions. This happens because `abi.encodePacked()` packs all elements in order, regardless of whether they are part of an array. As a result, elements can be moved between arrays, and as long as they remain in the same order, the encoding will be the same. In a signature verification scenario, an attacker could exploit this by modifying the position of elements in a previous function call to bypass authorization.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

contract Example {
    function getHash(address[] memory addresses1, address[] memory addresses2) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(addresses1, addresses2));
    }
}
```

In this example, the hash of `abi.encodePacked([addr1], [addr2, addr3])` will be the same as `abi.encodePacked([addr1, addr2], [addr3])`, leading to a hash collision¹.

#### Prevention:
1. **Use `abi.encode()` Instead**: Instead of using `abi.encodePacked()`, use `abi.encode()`, which includes the length of the arrays in the encoding, preventing collisions.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       function getHash(address[] memory addresses1, address[] memory addresses2) public pure returns (bytes32) {
           return keccak256(abi.encode(addresses1, addresses2));
       }
   }
   ```

2. **Avoid User-Controlled Parameters**: Do not allow users to control parameters used in `abi.encodePacked()`. This reduces the risk of manipulation.

3. **Use Fixed-Length Arrays**: If possible, use fixed-length arrays to ensure that the positions of elements cannot be modified.

4. **Replay Protection**: Implement replay protection mechanisms to prevent attackers from reusing valid signatures. Refer to [SWC-121](https://swcregistry.io/docs/SWC-121) for more details.

By following these best practices, you can mitigate the risk of hash collisions and enhance the security of your smart contracts.



¹: [ABI Hash Collisions - Smart Contract Security Field Guide](https://scsfg.io/hackers/abi-hash-collisions/)

Source: Conversation with Copilot, 8/14/2024
(1) ABI Hash Collisions - Smart Contract Security Field Guide. https://scsfg.io/hackers/abi-hash-collisions/.
(2) New Smart Contract Weakness: Hash Collisions With Multiple Variable .... https://medium.com/@0xkaden/new-smart-contract-weakness-hash-collisions-with-multiple-variable-length-arguments-dc7b9c84e493.
(3) SWC-133 - Smart Contract Weakness Classification (SWC). https://swcregistry.io/docs/SWC-133/.
(4) Hash Collision Attacks in 2024: Exploit Explained - LayerLogix. https://layerlogix.com/hash-collision-attacks-explained/.
(5) Common Vulnerabilities in Solidity and How to Address Them. https://www.soliditylibraries.com/tools/common-vulnerabilities-solidity-address/.
(6) solidity - Can abi.encode receive different values and return the same .... https://ethereum.stackexchange.com/questions/113188/can-abi-encode-receive-different-values-and-return-the-same-result.
(7) Hash Collisions With Multiple Variable Length Arguments. https://github.com/0xSojalSec/Solidity-Attack-Vectors/blob/main/data/21.md.