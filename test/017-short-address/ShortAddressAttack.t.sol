// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/017-short-address/ShortAddressAttack.sol";

contract ShortAddressAttackTest is Test {
    ShortAddressAttack shortAddressAttack;

    function setUp() public {
        shortAddressAttack = new ShortAddressAttack();
    }

    function testShortAddressAttack() public {
        // Simulate a deposit to set up balances
        shortAddressAttack.deposit{value: 1 ether}();

        // Create a short address by trimming down an existing address
        // In this case, the short address is intentionally invalid
        bytes
            memory shortAddressBytes = hex"0000000000000000000000000000000000000000"; // 18 byte address, meaning a short address
        address shortAddress;
        assembly {
            // Load 32 bytes from memory starting from the 18th byte,
            // but it will only take the last 20 bytes to create a short address
            shortAddress := mload(add(shortAddressBytes, 10))
        }

        // Try to transfer to the short address
        // The expected behavior is that this will fail due to invalid address
        vm.expectRevert();
        shortAddressAttack.transfer(shortAddress, 1 ether);

        // Assert that the balance remains unchanged
        assertEq(
            shortAddressAttack.balances(address(this)),
            1 ether,
            "Balance should not have been transferred because of short address"
        );
    }
}
