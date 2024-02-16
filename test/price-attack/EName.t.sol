// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {Test, console2} from "forge-std/Test.sol";
import {EName} from "../../src/price-attack/EName.sol";


contract ENameTest is Test{
    EName public enameContract;
    address treasury = makeAddr("treasury");

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");
    address user4 = makeAddr("user4");

    function setUp() public {
        enameContract = new EName(treasury);
        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(user3, 100 ether);
        vm.deal(user4, 100 ether);
        vm.deal(treasury, 100 ether);
    }

    function testRegisterFirstEName() public{
        vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);
        vm.stopPrank();
    }

    function testRegisterAgain() public{
        vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);
        vm.stopPrank();

        vm.startPrank(user2);
        vm.expectRevert("ename not available");
        enameContract.register{value: 0.1 ether}("luke");   
        vm.stopPrank();
    }

    function testBindNotOwner() public{
        vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);
        vm.stopPrank();

        vm.startPrank(user2);
        vm.expectRevert("Not owner");
        enameContract.bindEName("luke", user2);   
        vm.stopPrank();
    }

    function testBindAgain() public{
        vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);

        console2.log("user1 address", user1);
        console2.log("user2 address", user2);

        console2.log("luke address", enameContract.eaddress("luke"));
        console2.log("user1 ename:", enameContract.ename(user1));
        console2.log("user2 ename:", enameContract.ename(user2));

        enameContract.bindEName("luke", user2);

        console2.log("luke address", enameContract.eaddress("luke"));
        console2.log("user1 ename:", enameContract.ename(user1));
        console2.log("user2 ename:", enameContract.ename(user2));
        vm.stopPrank();
    }

    function testTransferOwner() public{
         vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);
        enameContract.transferFrom(user1, user2, enameContract.eNameToId("luke"));
        vm.stopPrank();

        assertEq(enameContract.ownerOf(enameContract.eNameToId("luke")), user2);
   }

    function testTransferRebind() public{
         vm.startPrank(user1);
        enameContract.register{value: 0.1 ether}("luke");
        enameContract.bindEName("luke", user1);
        enameContract.transferFrom(user1, user2, enameContract.eNameToId("luke"));
        vm.stopPrank();

        assertEq(enameContract.ownerOf(enameContract.eNameToId("luke")), user2);

        vm.startPrank(user2);
        enameContract.bindEName("luke", user2);
        vm.stopPrank();

        console2.log("user1 address", user1);
        console2.log("user2 address", user2);

        console2.log("luke address", enameContract.eaddress("luke"));
        console2.log("user1 ename:", enameContract.ename(user1));
        console2.log("user2 ename:", enameContract.ename(user2));
   }

    function testPriceAttack() public{
        // suppose user1 likes to register ename "luke" with 0.1 eth sending 1 ether:
        // 1) to cover some increase in price
        // 2) expect to receive the change

        // the treasury account or other users front-run to increase price
        vm.startPrank(treasury);
        for(uint256 i; i < 100; i++){
             enameContract.register{value: 1 ether}(Strings.toString(i));
        }
        vm.stopPrank();   

        uint256 preBalance = user1.balance;
        vm.startPrank(user1);
        enameContract.register{value: 1 ether}("luke");
        vm.stopPrank();
        uint256 postBalance = user1.balance;

        console2.log("paid:", preBalance - postBalance);
        assertEq(preBalance-postBalance, 270481382942152531); // paid 0.27 ether instead
    }
}
