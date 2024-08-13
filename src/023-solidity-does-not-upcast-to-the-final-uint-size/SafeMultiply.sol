// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SafeMultiply {
    // Function that multiplies two uint8 values and returns the result as uint256
    function safeMultiply(
        uint8 a,
        uint8 b
    ) public pure returns (uint256 product) {
        // Cast uint8 values to uint256 before performing the multiplication
        product = uint256(a) * uint256(b);
    }
}
