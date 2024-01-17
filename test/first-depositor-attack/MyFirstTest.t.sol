// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";

contract MyFirstTest is Test {
    address deployer = makeAddr("deployer");
    address victim1 = makeAddr("victim1");
    address victim2 = makeAddr("victim2");

    function setUp() public {
    }

    function testFirstTest() public {
       console2.log("My first test below");
       assertEq(1, 1);
    }

}
