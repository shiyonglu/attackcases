
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";

import {Auction} from "../../src/dos-attack/Auction.sol";
import {Attacker} from "../../src/dos-attack/Attacker.sol";


contract AuctionTest is Test {
      Auction auction;
      Attacker attacker;

      address tom = makeAddr("tom");
      address user1 = makeAddr("user1");

      function setUp() public {
            auction = new Auction();
            attacker = new Attacker(address(auction));  

            deal(user1, 100 ether);
            deal(tom, 10 ether);       
      }

      function testBid() public{
           // tom bid using attacker
           vm.prank(tom);
           attacker.attack{value: 10 ether}();

           console2.log("currentLeader: ", auction.currentLeader());

           console2.log("highestBid: ", auction.highestBid());
           assertEq(auction.currentLeader(), address(attacker));

           // user1 bid but fails
           vm.prank(user1);
           vm.expectRevert();
           auction.bid{value: 100 ether}();

           // same winner is attacker
           console2.log("highestBid: ", auction.highestBid());
           assertEq(auction.currentLeader(), address(attacker));
           
      }
}
