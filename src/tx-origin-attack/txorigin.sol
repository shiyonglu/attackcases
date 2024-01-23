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
