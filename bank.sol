// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bank{
    mapping(address => uint256)balance;
    

    function deposit() external payable{
        balance[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256){
        return balance[msg.sender];
    }

    function withdraw() external{
        uint256 amt = balance[msg.sender];
        msg.sender.call{value: amt}("");
        balance[msg.sender] = 0;
    }

    
}
