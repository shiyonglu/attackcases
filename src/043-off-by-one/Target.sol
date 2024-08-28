// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Target {
    bool public pwned = false;

    function isContract(address account) public view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function protected() external {
        require(!isContract(msg.sender), "No contract allowed");
        pwned = true;
    }
}
