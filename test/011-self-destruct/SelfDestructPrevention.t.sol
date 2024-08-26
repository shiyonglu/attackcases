// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/011-self-destruct/SelfDestructPrevention.sol";

contract SelfDestructPreventionTest is Test {
    EtherGame public etherGame;
    Attack public attackContract;

    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        etherGame = new EtherGame();
        attackContract = new Attack(etherGame);
    }

    function testAttackFailsDueToBalanceProtection() public {
        // Alice and Bob deposit 1 ether each
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.deal(bob, 1 ether);
        vm.startPrank(bob);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        // Check that the game balance is correctly tracked and is 2 ether
        assertEq(etherGame.balance(), 2 ether);

        // Now the Attack contract tries to send 5 ether to break the game
        vm.deal(address(attackContract), 5 ether);
        vm.startPrank(address(attackContract));
        attackContract.attack{value: 5 ether}();
        vm.stopPrank();

        // Check that the actual balance on the contract is still 2 ether (unchanged)
        assertEq(etherGame.balance(), 2 ether);
        assertEq(address(etherGame).balance, 7 ether); // including attacker's ether

        // Try to deposit again, which should succeed if balance protection works
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);
        etherGame.deposit{value: 1 ether}();
        assertEq(etherGame.balance(), 3 ether);
        vm.stopPrank();

        // Three players  deposit 1 ether each
        for (uint256 i = 1; i <= 3; i++) {
            address player = address(uint160(i));
            vm.deal(player, 1 ether);
            vm.startPrank(player);
            etherGame.deposit{value: 1 ether}();
            vm.stopPrank();
        }

        // The seventh deposit should make the sender the winner
        vm.deal(bob, 1 ether);
        vm.startPrank(bob);
        etherGame.deposit{value: 1 ether}();
        assertEq(etherGame.winner(), bob);
        assertEq(etherGame.balance(), 7 ether);
        vm.stopPrank();

        // Bob can successfully claim the reward
        vm.startPrank(bob);
        assertEq(bob.balance, 0);
        assertEq(etherGame.balance(), 7 ether);
        etherGame.claimReward();
        assertEq(bob.balance, 7 ether);
        assertEq(etherGame.balance(), 0);
        vm.stopPrank();
    }
}
