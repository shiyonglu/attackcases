// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "src/009-reentrancy/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    Attacker public attacker;

    address payable owner;
    address payable attackerAddress;

    receive() external payable {}

    function setUp() public {
        // Deploy the Bank contract
        bank = new Bank();

        // Set up owner and attacker accounts
        owner = payable(address(this));
        attackerAddress = payable(vm.addr(1));

        // Deploy the Attacker contract with the Bank address
        vm.prank(attackerAddress);
        attacker = new Attacker(payable(address(bank)));
    }

    function testDeposit() public {
        // Deposit 1 ether from the owner account
        bank.deposit{value: 1 ether}();
        assertEq(bank.getBalance(), 1 ether);
    }

    function testWithdraw() public {
        // Deposit 1 ether from the owner account
        bank.deposit{value: 1 ether}();
        assertEq(bank.getBalance(), 1 ether);

        // Withdraw the deposited ether
        bank.withdraw();
        assertEq(bank.getBalance(), 0);
    }

    function testReentrancyAttack() public {
        // Add funds from different accounts
        vm.deal(address(1), 1 ether);
        vm.prank(address(1));
        bank.deposit{value: 1 ether}();

        vm.deal(address(2), 1 ether);
        vm.prank(address(2));
        bank.deposit{value: 1 ether}();

        assertEq(address(bank).balance, 2 ether);

        // Deposit 1 ether from the attacker account to the Bank contract
        vm.deal(attackerAddress, 1 ether);
        vm.prank(attackerAddress);
        attacker.attack{value: 1 ether}();

        // Attacker should have all of the money
        assertEq(attackerAddress.balance, 3 ether);

        // Bank should be empty
        assertEq(address(bank).balance, 0);
    }
}
