// Merkle Tree generation 
const wscOwnerAddresses = require('./wscOwnerAddressesSnapshot.json');
const { getAddress} = require('ethers');
const { MerkleTree } = require('merkletreejs');
const keccac256 = require('keccak256');

/**
 * @IMPORTANT Using this program to interact directly with the deployed refund contract
 * is an agreement to the refund policy.
 */

// Utility Functions

function generateRealAddressList() {    
    const addresses = Object.keys(wscOwnerAddresses);
    return addresses;
}

function generateMerkleTreeAbstract(addresses) {
    const leaves = addresses.map(x => keccac256(x));
    const tree = new MerkleTree(leaves, keccac256, { sortPairs: true});
    return [tree, leaves];
}

function generateMappingOfAddressesToLeaves(addresses, leaves) {
    const mapping = {};
    for (let i = 0; i < addresses.length; i++) {
        const address = addresses[i];
        const leaf = leaves[i];
        mapping[address] = leaf;
    }
    return mapping;
}

// Higher Order Functions

/**
 * Used in order to generate the proof of a specific wallet address, which
 * can be used to directly interact with the contract and provide the proof
 * of one's ethereum address, which is required to claim one's refund.
 * 
 * @param {String: EthereumAddress} address 
 * @returns {}
 */
function getMerkleProof(address) {
    if (!address) throw new Error("Address is required");
    if (typeof address !== 'string') throw new TypeError("Address must be a string");
    console.log("🚀 ~ getMerkleProof ~ address:", address)
    // const testAddresses = generateFakeAddressList();
    const testAddresses = generateRealAddressList();
    const [merkleTree, leaves] = generateMerkleTreeAbstract(testAddresses);
    console.log("🚀 ~ getMerkleProof ~ merkleTree:", merkleTree)
    const mappingOfTreeToLeaves = generateMappingOfAddressesToLeaves(testAddresses, leaves);
    console.log("🚀 ~ getMerkleProof ~ mappingOfTreeToLeaves:", mappingOfTreeToLeaves)
    const checksummedAddress = getAddress(address);
    console.log("🚀 ~ getMerkleProof ~ checksummedAddress:", checksummedAddress)
    const leaf = mappingOfTreeToLeaves[checksummedAddress];
    const hexProof = merkleTree.getHexProof(leaf);
    console.log("🚀 ~ getMerkleProof ~ hexProof:", hexProof)
    return hexProof;
}

/**
 * Allows any external auditor or individual to verify
 * that the root stored within the contract matches the 
 * root generated here, which is generated using all of the
 * addresses holding the ERC-721 token at snapshot time. 
 * 
 * @private_comment This means that we are using cryptography
 * to generate a hash that represents an "aggregate" of all 
 * the addresses that are whitelisted in the contract - if
 * an address is missing from the list in wscOwnerAddressesSnapshot.json
 * or if there is an additional address that isn't on the list, the
 * generated hash would be different.
 * 
 * In thi way, the hash is both a constraint and a "proof" as to the 
 * addresss that are allowed to be whitelisted. 
 * 
 * @further_reading
 * - Merkle Trees Wikipedia: https://en.wikipedia.org/wiki/Merkle_tree
 * - Merkle Trees in Blockchain: https://learn.bybit.com/blockchain/what-is-merkle-tree/
 */
function getRoot() {
    const addresses = generateRealAddressList();
    const [merkleTree, leaves] = generateMerkleTreeAbstract(addresses);
    const rootHash = merkleTree.getRoot().toString('hex');
    console.log("🚀 ~ getRoot ~ rootHash:", rootHash)
    const root = merkleTree.getRoot();
    console.log("🚀 ~ getRoot ~ root:", root)
    return root;
}

getRoot();

// const TEST_ADDRESS = "";
// getMerkleProof(TEST_ADDRESS);
