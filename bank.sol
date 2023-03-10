// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract bank{
    mapping(address => uint256)balances;
    

    function deposit() external payable{
        balances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256){
        return balances[msg.sender];
    }

    function withdraw() external{
        uint256 amt = balances[msg.sender];
        (bool success, ) = msg.sender.call{value: amt}(""); // must check return value of a low-level call
        if(!success) revert();
        balances[msg.sender] = 0;
    }

receive() payable external 
{

}   
}
