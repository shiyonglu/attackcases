// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Underflow{
    mapping(address => uint)balance;
    

    function deposit() external payable{
        balance[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }

    function transfer(address receiver, uint amt) external{
        require(balance[msg.sender] - amt >= 5);
        balance[msg.sender] = balance[msg.sender] - amt;
        balance[receiver] = balance[receiver] + amt;
    }

    
}


contract Attacker {
    Underflow public  myunderflow;
    address public owner; 

    constructor(address payable _underflowContractAddress) {
        myunderflow = Underflow(_underflowContractAddress);
        owner=msg.sender;
    }

}
