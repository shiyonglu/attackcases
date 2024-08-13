# AttackRepo
This repository contains various smart contract attacks. It can be used to test the performance of different smart contract audit tools. This repository is compatible with Foundry. To test each vulnerability, clone this repository to your PC, compile it using the forge compile command, and run all tests using the forge test command.

Here is the list of the vulnerabilities: 

 
 1.	Distribution
 2.	Denial of Service (DOS)
 3.	First-depositor-attack
 4.	Flashloan-attack
 5.	Front Running
 6.	Arithmetic Overflow-Underflow
 7.	Permit-dos-attack
 8.	Price-attack
 9.	Reentrancy attack
10.	Reorg attack
11.	Self Destruct attack
12.	tx-origin -attack
13.	Access control
14.	Unchecked Low Level Calls
15.	Bad Randomness
16.	Time manipulation
17.	Short Address
18.	Improper Input Validation
19.	Double voting or msg.sender spoofing
20.	Bypassing the contract check
21.	Mixed accounting
22.	Treating cryptographic proofs like passwords
23.	Solidity does not upcast to the final uint size
24.	Solidity sneakily makes some literals uint8
25.	Solidity downcasting does not revert on overflow
26.	Writes to storage pointers don’t save new data
27.	Deleting structs that contain dynamic datatypes does not delete the dynamic data
28.	ERC20 Fee on transfer
29.	ERC20 rebasing tokens
30.	ERC20 ERC777 in ERC20 clothing
31.	ERC20 Not all ERC20 tokens return true
32.	msg.value in a loop
33.	Private Variables
34.	Overpowered Admins
35.	Use Ownable2Step instead of Ownable
36.	Rounding Errors
37.	Signatures ecrecover returns invalid address
38.	Signature replay
39.	Signature malleability
40.	Signatures can be forged or crafted without proper safeguards
41.	Transfer() and send() can break with multi-signature wallets
42.	Corner Case
43.	Off-By-One
44.	Account Existence Check for low level calls
45.	Assert Violation
46.	Bypass Contract Size Check
47.	Code With No Effects
48.	Entropy Illusion
49.	Function Selector Abuse
50.	Floating Pragma
51.	Forcibly Sending Ether to a Contract
52.	Function Default Visibility
53.	Hash Collisions With Multiple Variable Length Arguments
54.	Improper Array Deletion
55.	Incorrect interface
56.	Unsafe Ownership Transfer
57.	Message call with hardcoded gas amount
58.	Hiding Malicious Code with External Contract
59.	Public burn() function
60.	Requirement Violation
61.	Right-To-Left-Override control character (U+202E)
62.	Shadowing State Variables
63.	Typographical Error
64.	Unencrypted Private Data On-Chain
65.	Unexpected Ether balance
66.	Uninitialized Storage Pointer
67.	Unprotected Ether Withdrawal
68.	Unprotected Upgrades
69.	Use of Deprecated Solidity Functions
70.	Write to Arbitrary Storage Location
71.	Wrong inheritance
72.	Unsupported Opcodes
73.	Write to Arbitrary Storage Location
74.	Hash Collision when using abi.encodePacked() with Multiple Variable-Length Arguments
75.	Incorrect Inheritance Order
76.	Inadherence to Standards
77.	Asserting Contract from Code Size
78.	Insufficient Access Control
79.	Lack of Precision
80.	Unbounded Return Data
81.	Deleting a Mapping Within a Struct
82.	Ambiguous Evaluation Order
83.	Approval Vulnerabilities
84.	Incorrect Parameter Order
85.	Oracle Manipulation Attacks
86.	Unexpected Ether Transfers
87.	Dos > Offline Owner
88.	Privacy Illusion
89.	External Contract Referencing
90.	Arbitrary Jumps with Function Variables
91.	Dirty Higher Order Bits
92.	Complex Modifiers
93.	Experimental Language Features
94.	Call Depth Attack
95.	Historic Attacks > Constructor Names
96.	Payable Multicall
97.	Presence of unused variables
98.	Lack of Proper Signature Verification
99.	Block values as a proxy for time

 