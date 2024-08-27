// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/012-tx-origin-attack/txorigin.sol";

contract TxOriginTest is Test {
    TxOrigin public txOrigin;
    AttackContract public attackContract;

    function setUp() public {
        txOrigin = new TxOrigin();
        attackContract = new AttackContract(address(txOrigin));
        vm.deal(address(txOrigin), 1 ether);
    }

    function testWithdrawAsOwner() public {
        // Set up the owner's balance
        

        // Withdraw as the owner
        txOrigin.withdraw();

        // Assert that the owner's balance has been transferred
        assertEq(address(txOrigin).balance, 0);
    }

    function testWithdrawAsAttacker() public {
        // Set up the attacker's balance

        // Attack the vulnerable contract
        attackContract.attack();

        // Assert that the vulnerable contract's balance has been transferred to the attacker
        assertEq(address(txOrigin).balance, 0);
        assertEq(address(attackContract).balance, 1 ether);
    }

    function testWithdrawRevertsIfNotAuthorized() public {
        // Try to withdraw as an unauthorized user
        vm.expectRevert("Not authorized");
        txOrigin.withdraw();
    }

}