// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/011-self-destruct/SelfDestruct.sol";

contract SelfDestructTest is Test {
    EtherGame public etherGame;
    Attack public attackContract;

    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        etherGame = new EtherGame();
        attackContract = new Attack(etherGame);

        // Fund Alice and Bob with 1 ether each
        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);

        // Fund the Attack contract with 5 ether
        vm.deal(address(attackContract), 5 ether);
    }

    function testClaimRewardSuccess() public {
        // Six players (including Alice and Bob) deposit 1 ether each
        for (uint256 i = 1; i <= 6; i++) {
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
        vm.stopPrank();

        // Bob can successfully claim the reward
        vm.startPrank(bob);
        etherGame.claimReward();
        vm.stopPrank();

        // Check that the balance of the EtherGame contract is now 0
        assertEq(address(etherGame).balance, 0);
    }

    function testSuccessfulAttack() public {
        // Alice and Bob deposit 1 ether each
        vm.startPrank(alice);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.startPrank(bob);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        // Check that the game balance is 2 ether
        assertEq(address(etherGame).balance, 2 ether);

        // Now the Attack contract sends 5 ether to break the game
        vm.startPrank(address(attackContract));
        attackContract.attack{value: 5 ether}();
        vm.stopPrank();

        // Check that the game balance is now 7 ether
        assertEq(address(etherGame).balance, 7 ether);

        // Try to deposit again, which should fail because the game is over
        vm.expectRevert("Game is over");
        etherGame.deposit{value: 1 ether}();
    }

    function testClaimRewardFailure() public {
        // Simulate attack and broken game scenario
        vm.startPrank(alice);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        vm.startPrank(bob);
        etherGame.deposit{value: 1 ether}();
        vm.stopPrank();

        // Attack to reach the 7 ether target balance
        vm.startPrank(address(attackContract));
        attackContract.attack{value: 5 ether}();
        vm.stopPrank();

        // Alice tries to claim the reward, but since she is not the winner, it should revert
        vm.startPrank(alice);
        vm.expectRevert("Not winner");
        etherGame.claimReward();
        vm.stopPrank();
    }
}
