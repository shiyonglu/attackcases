// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/036-rounding-errors/RoundingError.sol";  // Update the path according to your directory structure

contract RoundingErrorTest is Test {
    Exchange exchange;

    function setUp() public {
        exchange = new Exchange();
    }

    function testRoundingErrorSmallUSDCAmount() public {
        uint256 smallUSDCAmount = 1;  // Very small amount of USDC (1 unit)

        // Call the swap function
        uint256 daiToTake = exchange.swapDAIForUSDC(smallUSDCAmount);

        // Assert that daiToTake is not zero
        assertGt(daiToTake, 0, "daiToTake should not be zero for small USDC amount");
    }

    function testRoundingErrorLargerUSDCAmount() public {
        uint256 largerUSDCAmount = 1e6;  // 1 million USDC (considering 6 decimals)

        // Call the swap function
        uint256 daiToTake = exchange.swapDAIForUSDC(largerUSDCAmount);

        // Assert that the calculation is correct
        uint256 expectedDAIToTake = (largerUSDCAmount * 1e12) / 1e18;
        assertEq(daiToTake, expectedDAIToTake, "Incorrect DAI amount taken for larger USDC amount");
    }
}
