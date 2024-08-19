# Reorg Attack  
This repo demonstrates a reorganization (reorg) attack scenario within a decentralized application (dApp) using Solidity smart contracts. The reorg attack involves manipulating the blockchain by reorganizing the blocks, which can lead to vulnerabilities, especially in contract deployment processes. This example highlights the importance of secure contract deployment and salt usage to prevent such attacks.

# Contracts Overview
PPSwap.sol
The PPSwap contract is a simple ERC20 token contract with a fixed supply.

### Key Components:

constructor(): Mints 1 billion PPSwap tokens to the deployer.
TokenB.sol
The TokenB contract is an ERC4626-compliant tokenized vault. It allows the owner to withdraw ETH and manage assets.

### Key Components:

constructor(IERC20 _asset): Initializes the vault with a specific ERC20 asset.
withdrawETH(): Allows the owner to withdraw the ETH balance from the vault.
TokenBFactory.sol
The TokenBFactory contract is responsible for deploying new instances of the TokenB contract. It initially contains a vulnerability that can be exploited through a reorg attack.

### Key Components:

deployTokenB(address assetToken, bytes32 _salt): Deploys a new TokenB instance using a specified salt for deterministic deployment. The initial implementation is vulnerable to reorg attacks.
 
# What is a Reorg Attack?
A reorganization (reorg) attack occurs when an attacker manipulates the blockchain by creating a fork and reorganizing the order of blocks. This can allow an attacker to replace transactions in the blockchain's history, effectively undoing previous transactions. In the context of smart contracts, this can lead to vulnerabilities, especially when deploying contracts with deterministic addresses.

## How the Attack Works
Vulnerability in Salt Usage:

The TokenBFactory contract uses a salt value for deterministic deployment of TokenB instances.
If the salt value is predictable, an attacker can manipulate the blockchain to replace the block containing the original deployment transaction with a new one, using the same salt but altering other parameters to gain control over the deployed contract.
Reorganization:

An attacker can create a fork in the blockchain and mine a new block that reorganizes the chain, replacing the original contract deployment with one that benefits the attacker.
The attacker can then gain control over the deployed TokenB contract or manipulate its state.
Impact:

The attacker could potentially gain ownership of the TokenB contract, allowing them to withdraw ETH or manipulate the assets within the vault.
Example Scenario
Step 1: A user deploys a TokenB contract using TokenBFactory with a predictable salt.
Step 2: The attacker observes the salt and creates a fork to reorganize the blockchain, replacing the original block.
Step 3: The attacker’s transaction is now part of the canonical chain, and they gain control over the TokenB contract.

## Mitigation Strategy
Secure Salt Usage
To prevent reorg attacks, the TokenBFactory contract should use a secure salt generation method that includes additional unpredictable elements, such as the sender's address.

# Improved Implementation:

Use Secure Salt Generation: Always use unpredictable elements, such as the sender’s address, when generating salts for contract deployment.
Avoid Deterministic Addresses: Where possible, avoid deterministic contract addresses or ensure that they are secure against reorg attacks.
Monitor Blockchain Reorgs: Keep an eye on blockchain reorganizations, especially in scenarios where contract deployments or critical transactions are involved.