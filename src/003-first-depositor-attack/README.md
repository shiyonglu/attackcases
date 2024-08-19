# First Depositor Attack

## Overview
This repository contains smart contracts for the PPSVault and PPSVaultFactory written in Solidity. The PPSVault contract implements the ERC-4626 tokenized vault standard, allowing users to deposit ERC-20 tokens and receive vault shares in return. The PPSVaultFactory contract is used to deploy new instances of PPSVault for different underlying assets.

## Contracts:
PPSVault.sol: Implements the ERC-4626 vault standard, enabling the creation of tokenized vaults where users can deposit an underlying ERC-20 token and receive shares in return.
PPSVaultFactory.sol: A factory contract used to deploy new instances of the PPSVault contract for different ERC-20 tokens.
PPSwap.sol: A basic ERC-20 token contract named "PPSwap" with a fixed supply.
The First Depositor Attack
What is the First Depositor Attack?
The "First Depositor Attack" is a potential vulnerability in ERC-4626 vaults, particularly when they are first deployed and have no prior deposits. The attack involves an initial depositor manipulating the share price of the vault through a donation or inflation attack. This is possible when the vault is empty or nearly empty, allowing the first depositor to unfairly influence the initial exchange rate between the vault’s shares and its underlying assets.

## How the Attack Works:
Initial Deposit: The vault is newly deployed and empty. The first depositor deposits a small amount of the underlying asset, setting the initial exchange rate between the shares and the assets.

Donation/Inflation Attack: The attacker then donates additional assets to the vault without receiving any shares in return. This artificially inflates the total assets in the vault, causing the share price to increase.

Subsequent Deposits: When other users deposit assets into the vault, they receive fewer shares than they should because of the inflated share price. The attacker can then redeem their shares for a disproportionate amount of the underlying assets, profiting at the expense of other depositors.

## Mitigation Strategies:
To mitigate the risks of the First Depositor Attack in PPSVault, consider the following strategies:

Initial Deposit Size: Ensure that the initial deposit is substantial enough to make price manipulation through a donation attack infeasible.
Virtual Shares and Assets: Use virtual shares and assets to pre-set an exchange rate, making it more difficult and less profitable for attackers to manipulate the vault.
Security Audits: Conduct thorough security audits of the contract to ensure there are no other vulnerabilities that could be exploited in conjunction with this attack.
