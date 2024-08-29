// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";
import {VulnerableToken} from "src/017-short-address/VulnerableToken.sol";

contract Deploy17ShortAddressAttack is Script {
    function run() external {
        vm.startBroadcast();
        VulnerableToken vulnerableToken = new VulnerableToken();
        console2.log("VulnerableToken deployed at:", address(vulnerableToken));
        vm.stopBroadcast();
    }
}
