# Price Attack  
 
## Introduction
This project demonstrates a potential price manipulation attack on the EName smart contract, which allows users to register unique names (eNames) as NFTs. The contract is designed to increase the registration price by 1% after each successful registration. However, this price adjustment mechanism can be exploited by attackers through front-running, leading to significant economic loss or price manipulation.

## Contract Overview
EName.sol
The EName contract allows users to register and bind unique eNames as ERC721 tokens. Each registration increases the price of the next registration by 1%. The contract also includes functions for binding eNames to specific Ethereum addresses, ensuring a one-to-one relationship between an eName and an address.

## Key Components:

register(string memory _ename) payable public: Allows a user to register a new eName by paying the current price. The price increases by 1% after each successful registration.
bindEName(string memory _ename, address account) public: Allows the owner of an eName to bind it to a specific Ethereum address.
_toLower(string memory str) internal pure returns (string memory): A helper function to convert a string to lowercase.
The Price Attack
What is a Price Attack?
A price attack in this context refers to the manipulation of the registration price by malicious actors through front-running. Front-running occurs when an attacker anticipates a transaction and executes their transaction first to gain an advantage.

## How the Attack Works
Price Increment Mechanism:

Every time an eName is registered, the price for the next registration increases by 1%.
This incremental price change is stored in the price variable within the register function.
Front-Running Vulnerability:

An attacker can observe a pending transaction to register an eName.
The attacker then submits their transaction with a higher gas fee, ensuring it gets mined first.
By doing this, the attacker forces the price of the subsequent registration (the victim’s transaction) to increase by 1% before the victim’s transaction is executed.
If the attacker repeats this process, they can significantly inflate the registration price in a short period.
Resulting Impact:

The victim ends up paying more than they initially anticipated for the registration.
The attacker can potentially profit by manipulating the price and selling the eNames at inflated prices or causing financial strain on other users.
Example Scenario
Initial price: 0.1 ETH
Attacker registers an eName: Price increases to 0.101 ETH
Victim tries to register an eName: Attacker front-runs, registering another eName.
New price after attacker’s second registration: 0.10201 ETH
Victim’s transaction is executed: Victim pays 0.10201 ETH instead of 0.1 ETH.
# Security Considerations
To mitigate the risk of price manipulation attacks:

Delay Price Update: Consider implementing a time delay between the registration and the price update, reducing the chances of front-running.
Cap Price Increase: Introduce a cap on the maximum price increase per transaction or over a certain period.
Anti-Front-Running Measures: Implement anti-front-running techniques such as Commit-Reveal schemes or adjusting the price increment algorithm to make it less predictable.