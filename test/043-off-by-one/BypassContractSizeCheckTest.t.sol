// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/043-off-by-one/Target.sol";
import "../../src/043-off-by-one/Hack.sol";

contract BypassContractSizeCheckTest is Test {
    Target target;

    function setUp() public {
        target = new Target();
    }

    function testBypassContractSizeCheck() public {
        // Ensure pwned is false before the attack
        assertFalse(target.pwned(), "Target should not be pwned before the attack");

        // Deploy the Hack contract, which should exploit the vulnerability
        new Hack(address(target));

        // Check if the Hack contract succeeded in bypassing the contract size check
        assertTrue(target.pwned(), "Target should be pwned after the attack");
    }
}
