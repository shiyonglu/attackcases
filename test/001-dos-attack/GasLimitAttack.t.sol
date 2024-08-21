// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";

import "forge-std/Test.sol";
import "src/001-dos-attack/GasLimitAttack.sol";
import "src/001-dos-attack/GasLimitReachedExample.sol";

contract GasLimitAttackTest is Test {
    GasLimitReachedExample public example;
    GasLimitAttack public attack;

    function setUp() public {
        example = new GasLimitReachedExample();
        attack = new GasLimitAttack(address(example));
    }

    function testAttack_GasLimitAttack() public {
        vm.expectRevert();
        attack.attack();
    }
}