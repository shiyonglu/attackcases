# Double Voting Vulnerability in Vanilla ERC20 Tokens
Overview
Using vanilla ERC20 tokens or NFTs as tickets to weigh votes in a decentralized application can be unsafe. Attackers can vote with one address, transfer the tokens to another address, and vote again from that address. This document explains the vulnerability and provides a solution using ERC20 Snapshot or ERC20 Votes to prevent such attacks.

# Vulnerability Explanation
In a naive implementation of a voting system using ERC20 tokens, an attacker can exploit the system by transferring tokens between addresses and voting multiple times. This undermines the integrity of the voting process.