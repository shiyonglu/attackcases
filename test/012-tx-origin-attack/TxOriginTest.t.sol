// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/012-tx-origin-attack/txorigin.sol";

contract TxOriginTest is Test {
    TxOrigin public txOrigin;
    AttackContract public attackContract;
    address me = address(1);

    function setUp() public {
        // tx.origin related issue https://ethereum.stackexchange.com/q/147319/99242

        vm.startPrank(address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38));
        txOrigin = new TxOrigin();
        attackContract = new AttackContract(address(txOrigin));
        vm.stopPrank();

        vm.deal(address(txOrigin), 10 ether);
    }

    receive() external payable {}

    function testWithdrawAsOwner() public {
        assertEq(address(txOrigin).balance, 10 ether);

        // Withdraw as the owner
        vm.startPrank(address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38));

        emit log_named_address("Test tx.origin", tx.origin);
        emit log_named_address("Test msg.sender", msg.sender);
        emit log_named_address("Test address", address(this));

        (bool success,) = address(txOrigin).call(abi.encodeWithSignature("withdraw()"));
        require(success, "Withdraw failed");

        vm.stopPrank();

        // Assert that the owner's balance has been transferred
        assertEq(address(txOrigin).balance, 0);
    }

    function testWithdrawAsAttacker() public {
        assertEq(address(txOrigin).balance, 10 ether);

        // Withdraw as the attacker
        vm.startPrank(address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38));

        emit log_named_address("Test tx.origin", tx.origin);
        emit log_named_address("Test msg.sender", msg.sender);
        emit log_named_address("Test address", address(this));

        attackContract.attack();

        vm.stopPrank();

        assertEq(address(txOrigin).balance, 0);
        assertEq(address(attackContract).balance, 10 ether);
    }

    function testWithdrawSecureAsAttacker() public {
        assertEq(address(txOrigin).balance, 10 ether);

        // Withdraw as the attacker
        vm.startPrank(address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38));

        emit log_named_address("Test tx.origin", tx.origin);
        emit log_named_address("Test msg.sender", msg.sender);
        emit log_named_address("Test address", address(this));

        vm.expectRevert();
        attackContract.attack_secure();

        vm.stopPrank();

        assertEq(address(txOrigin).balance, 10 ether);
        assertEq(address(attackContract).balance, 0);
    }
}
