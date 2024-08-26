// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/006-overflow-underflow/ArithmeticIssue.sol";

contract ArithmeticIssueTest is Test {
    ArithmeticIssue public arithmeticIssue;
    address public attacker = address(0x1);

    function setUp() public {
        // Deploy the ArithmeticIssue contract
        arithmeticIssue = new ArithmeticIssue();

        // Fund the contract with 10 ether
        vm.deal(address(arithmeticIssue), 5 ether);

        // Fund the attacker with 1 ether
        vm.deal(attacker, 1 ether);
    }

    function testDepositAndWithdraw() public {
        // Attacker deposits 1 ether
        vm.startPrank(attacker);
        arithmeticIssue.deposit{value: 1 ether}();
        assertEq(arithmeticIssue.getBalance(), 1 ether);

        // Attacker tries to withdraw more than their balance
        vm.expectRevert();
        arithmeticIssue.withdraw(2 ether);

        // Attacker withdraws 0.5 ether successfully
        arithmeticIssue.withdraw(0.5 ether);
        assertEq(arithmeticIssue.getBalance(), 0.5 ether);

        vm.stopPrank();
    }

    function testUncheckedUnderflowAttack() public {
        // Attacker deposits 1 ether
        vm.startPrank(attacker);
        arithmeticIssue.deposit{value: 1 ether}();
        assertEq(arithmeticIssue.getBalance(), 1 ether);

        // Exploit the underflow issue using unchecked block
        arithmeticIssue.withdrawUnchecked(2 ether); // This would pass due to the unchecked block
        assert(arithmeticIssue.getBalance() > 100 ether); // The balance underflows to a very large number

        vm.stopPrank();
    }
}
