/*
  The flashload attack has the the vulnerablity at: it checks whether the new blancce against the old balance, 
  and assumes if the new balance is greater than the old balance of asset, then the loan has been returned.abi
   
   In reality, the loaner used the loaed asset tokens and depoit it back to the vault in the same transction. As 
   a result, it bypasseed the check. After the flash loan completes, the attackers simply redeems 
   his shares from the vault. The stealing completes. 
*/



// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PPSwap} from "../..//src/flashloan-attack/PPSwap.sol";
import {PPSVault} from "../../src/flashloan-attack/PPSVault.sol";
import {PPSVaultFactory} from "../../src/flashloan-attack/PPSVaultFactory.sol";
import {FlashLoanAttacker} from "../../src/flashloan-attack/FlashLoanAttacker.sol";


contract PPSVaultTest is Test {
    PPSwap ppswap;
    PPSVault ppsVault;
    PPSVaultFactory ppsVaultFactory;
    address deployer = makeAddr("deployer");
    bytes32 salt_ = keccak256(abi.encode("my salt"));
    address attacker = makeAddr("attacker");
    address depositor1 = makeAddr("depositor1");
    address depositor2 = makeAddr("depositor2");
    

    function setUp() public {
        ppswap = new PPSwap();
        ppswap.transfer(deployer, 2000 ether);  
        ppswap.transfer(depositor1, 2000 ether);
        ppswap.transfer(depositor2, 2000 ether);

        vm.startPrank(deployer);
        ppsVaultFactory = new PPSVaultFactory();
        ppsVault = ppsVaultFactory.deployPPSVault(address(ppswap), salt_);


        vm.startPrank(depositor1);
        ppswap.approve(address(ppsVault), 2000 ether);
        ppsVault.deposit(2000 ether, depositor1);
        vm.stopPrank();

        vm.startPrank(depositor2);
        ppswap.approve(address(ppsVault), 2000 ether);
        ppsVault.deposit(2000 ether, depositor2);
        vm.stopPrank();
    }

    function testFlashLoanAttack() public {
        console2.log("attacker PPS balance:", ppswap.balanceOf(attacker));
        vm.startPrank(attacker);
        FlashLoanAttacker flashLoanAttacker = new FlashLoanAttacker(address(ppsVault));
        flashLoanAttacker.callFlashLoan(3000 ether);
        vm.stopPrank();
        console2.log("attacker PPS balance:", ppswap.balanceOf(attacker));
    }
}
