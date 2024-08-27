// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/014-Unchecked-low-level-calls/FaultyWithdraw.sol";
import "src/014-Unchecked-low-level-calls/SafeWithdraw.sol";
import "src/014-Unchecked-low-level-calls/Attacker.sol";

contract WithdrawTest is Test {
    FaultyWithdraw public faultyWithdraw;
    Attacker public attackerContract;
    SafeWithdraw public safeWithdraw;

    address user1 = address(0x123);
    address attacker;

    function setUp() public {
        faultyWithdraw = new FaultyWithdraw();
        attackerContract = new Attacker();
        safeWithdraw = new SafeWithdraw();
        attacker = address(attackerContract);
    }

    function testDepositAndWithdraw() public {
        // Simulate a user depositing 1 ether
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        faultyWithdraw.deposit{value: 1 ether}();

        assertEq(faultyWithdraw.balances(user1), 1 ether);
        assertEq(faultyWithdraw.etherLeft(), 1 ether);

        // Simulate a successful withdrawal by user1
        vm.prank(user1);
        faultyWithdraw.withdraw(0.5 ether);

        assertEq(faultyWithdraw.balances(user1), 0.5 ether);
        assertEq(faultyWithdraw.etherLeft(), 0.5 ether);
    }

    function testWithdraw_FaultyWithdraw() public {
        // Simulate depositing ether into the FaultyWithdraw contract
        vm.deal(attacker, 1 ether);
        vm.startPrank(attacker);
        faultyWithdraw.deposit{value: 1 ether}();

        // Simulate an attacker causing the send() function to fail
        // vm.expectRevert(); // this doesn't work as revert is inside of another function (receive())
        faultyWithdraw.withdraw(1 ether);
        vm.stopPrank();

        // Check that the balances are incorrectly reduced due to the vulnerability
        assertEq(faultyWithdraw.balances(user1), 0 ether); // The balance was deducted
        assertEq(faultyWithdraw.etherLeft(), 0 ether); // The etherLeft was reduced
    }

    function testWithdraw_SafeWithdraw() public {
        // Simulate depositing ether into the FaultyWithdraw contract
        vm.deal(attacker, 1 ether);
        vm.startPrank(attacker);
        safeWithdraw.deposit{value: 1 ether}();

        // Simulate an attacker causing the send() function to fail
        vm.expectRevert();
        safeWithdraw.withdraw(1 ether);
        vm.stopPrank();

        // Ether should not be deducted from the contract but the user's balance should be reduced
        assertEq(safeWithdraw.balances(user1), 0 ether);
        assertEq(safeWithdraw.etherLeft(), 1 ether);
    }
}
