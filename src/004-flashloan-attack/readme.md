# Flash Loan Attack 

This repo demonstrates a simplified example of a flash loan attack using a custom smart contract setup. The contracts included simulate a scenario where an attacker can exploit a flash loan to gain an advantage by manipulating token pools.

Contracts
1. FlashLoanAttacker.sol
This contract is the primary attacker contract. It implements the Borrower interface to receive flash loans and execute the attack logic.

Key Functions:
constructor(address _pool): Initializes the attacker contract with a reference to the PPSVault pool contract.
onFlashLoan(address originator, uint256 amount): Callback function executed when a flash loan is received. Instead of repaying the loan immediately, the borrowed amount is deposited into the pool to exploit the situation.
callFlashLoan(uint amount): Initiates the flash loan from the PPSVault and subsequently redeems the tokens to the attacker's address.
2. PPSVault.sol
This contract is an implementation of an ERC4626-compliant tokenized vault. It provides a flashLoan function that allows users to borrow assets temporarily.

Key Functions:
constructor(IERC20 _asset): Initializes the vault with a specific asset token.
withdrawETH(): Allows the contract owner to withdraw ETH from the vault.
flashLoan(uint256 amount): Sends the specified amount of assets to the borrower and expects it to be returned within the same transaction.
3. PPSVaultFactory.sol
This contract is responsible for deploying new instances of the PPSVault contract using a specific salt for deterministic deployment.

Key Functions:
deployPPSVault(address assetToken, bytes32 _salt): Deploys a new PPSVault instance using the provided assetToken and a salt to create a unique contract address.
4. PPSwap.sol
This contract is a simple ERC20 token contract named "PPSwap" with a fixed supply of 1 billion tokens. It serves as a placeholder token used within the ecosystem.

 
# How It Works
The attacker contract (FlashLoanAttacker.sol) requests a flash loan from the PPSVault contract. Instead of returning the borrowed amount, it deposits the borrowed funds back into the vault, thereby manipulating the balance and causing a potential financial gain when it redeems its share from the vault.

 
