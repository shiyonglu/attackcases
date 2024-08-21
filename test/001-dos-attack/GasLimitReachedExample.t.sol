// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/001-dos-attack/GasLimitReachedExample.sol";

contract GasLimitReachedExampleTest is Test {   
    GasLimitReachedExample public gasLimitReachedExample;

    function setUp() public {
        gasLimitReachedExample = new GasLimitReachedExample();
    }

    function testSelectNextWinners() public {
        gasLimitReachedExample.selectNextWinners(100);
        assertEq(gasLimitReachedExample.largestWinner(), 100);
    }
}