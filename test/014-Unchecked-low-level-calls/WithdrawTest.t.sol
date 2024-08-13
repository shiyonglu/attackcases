// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/014-Unchecked-low-level-calls/FaultyWithdraw.sol";
import "../../src/014-Unchecked-low-level-calls/SafeWithdraw.sol";

contract WithdrawTest is Test {
    FaultyWithdraw faulty;
    SafeWithdraw safe;

    function setUp() public {
        faulty = new FaultyWithdraw();
        safe = new SafeWithdraw();
    }

    function testFaultyWithdraw() public {
        // Deposit some ether
        faulty.deposit{value: 1 ether}();

        // Attempt to withdraw and verify it fails
        uint256 initialBalance = address(this).balance;
        faulty.withdraw(1 ether);
        uint256 finalBalance = address(this).balance;

        // Check balances
        assertEq(faulty.balances(address(this)), 0);
        assertEq(faulty.etherLeft(), 0);
        assertEq(finalBalance, initialBalance);
    }

    function testSafeWithdraw() public {
        // Deposit some ether
        safe.deposit{value: 1 ether}();

        // Withdraw and verify success
        uint256 initialBalance = address(this).balance;
        safe.withdraw(1 ether);
        uint256 finalBalance = address(this).balance;

        // Check balances
        assertEq(safe.balances(address(this)), 0);
        assertEq(safe.etherLeft(), 0);
        assertEq(finalBalance, initialBalance + 1 ether);
    }
}
