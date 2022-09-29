// SPDX-License-Identifier: MIT
pragma solidity ^0.5.12;

contract underflow{
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
