// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./MixedAccounting.sol";

contract ForceEther {
    constructor() payable {}

    function destroyAndSend(address payable _to) public {
        selfdestruct(_to);
    }
}
