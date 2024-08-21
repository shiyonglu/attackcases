// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import {President} from "src/001-dos-attack//UnexpectedThrow.sol";
import {MaliciousContract} from "src/001-dos-attack//UnexpectedThrowAttack.sol";

contract UnexpectedThrowAttack is Test {
    President public presidentContract;
    MaliciousContract public maliciousContract;

    function setUp() public {
        presidentContract = new President();
        maliciousContract = new MaliciousContract();
    }

    receive() external payable {}

    function testBecomePresident() public {
        // Initial president is the deployer
        assertEq(presidentContract.president(), address(this));
        assertEq(presidentContract.price(), 1 ether);

        // Become the new president by paying 1 ether
        presidentContract.becomePresident{value: 1 ether}();
        assertEq(presidentContract.president(), address(this));
        assertEq(presidentContract.price(), 2 ether);
    }

    function testAttack_UnexpectedThrowAttack() public {
        // Set the malicious contract as the president
        vm.deal(address(maliciousContract), 1 ether);

        // MaliciousContract contract should call the `becomePresident` function
        vm.startPrank(address(maliciousContract));
        presidentContract.becomePresident{value: 1 ether}();
        assertEq(presidentContract.president(), address(maliciousContract));
        assertEq(presidentContract.price(), 2 ether);
        vm.stopPrank();

        // Try to become the president after the malicious contract
        vm.expectRevert("Payment to current president failed");
        presidentContract.becomePresident{value: 2 ether}();
    }
}
