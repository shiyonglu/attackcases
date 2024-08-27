// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/013-access-control/AccessControl.sol";

contract AccessControlTest is Test {
    address user1 = address(0x123);
    address attacker = address(0x456);

    function testInitContract() public {
        // Call initContract() as the first user (simulating contract deployment).
        vm.startPrank(user1);
        AccessControl accessControl = new AccessControl();
        assertEq(accessControl.owner(), address(0));
        accessControl.initContract();
        assertEq(accessControl.owner(), user1);
        vm.stopPrank();

        // Simulate an attacker calling initContract() and taking ownership.
        vm.prank(attacker);
        accessControl.initContract();
        assertEq(accessControl.owner(), attacker); // The attacker successfully took ownership
    }

    function testAccessControlSecureV2() public {
        // Call initContract() as the first user (simulating contract deployment).
        vm.startPrank(user1);
        AccessControlSecureV2 accessControlSecureV2 = new AccessControlSecureV2();
        assertEq(accessControlSecureV2.owner(), address(0));
        accessControlSecureV2.initContract();
        assertEq(accessControlSecureV2.owner(), user1);
        vm.stopPrank();

        // Simulate an attacker calling initContract() and taking ownership.
        vm.startPrank(attacker);
        vm.expectRevert("Contract is already initialized");
        accessControlSecureV2.initContract();
        assertEq(accessControlSecureV2.owner(), user1); // The attacker failed to take ownership
    }
}
