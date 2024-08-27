// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/012-tx-origin-attack/txorigin.sol";

contract TxOriginTest is Test {
    TxOrigin vulnerableContract;
    AttackContract attackContract;
    address attacker = address(0xDEAD);

    function beforeEach() public {
        vulnerableContract = new TxOrigin();
        attackContract = new AttackContract(address(vulnerableContract));

        // Fund the vulnerable contract with 10 Ether
        vm.deal(address(vulnerableContract), 10 ether);
    }

    function testAttack_TxOrigin() public {
        assertEq(address(vulnerableContract).balance, 10 ether);
        assertEq(address(attackContract).balance, 0);

        vm.startPrank(attacker);
        attackContract.attack();
        vm.stopPrank();

        assertEq(address(vulnerableContract).balance, 0);
        assertEq(address(attackContract).balance, 10 ether);
    }
}
