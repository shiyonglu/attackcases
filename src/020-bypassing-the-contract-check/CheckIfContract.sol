// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheckIfContract {
    function addressIsContract(address _a) public view returns (bool) {
        return _a.code.length != 0;
    }
}
