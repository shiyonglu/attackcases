// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract TokenA is ERC20Permit{
    constructor(
       string memory name 
    ) ERC20Permit(name) ERC20(name, "AAA"){}

    function transferFromByPermit(        // anybody can execute this
        address from,                    // owner, approval owner as well as from
        address to,                      
        uint256 amount,
        uint256 approvalAmount,
        uint256 deadline,
        uint8 v, 
        bytes32 r, 
        bytes32 s
    ) public {            
       permit(      // verifies the permit, advance the nonce, and then approve allowance to the spender, msg.sender
                from,                     // owner
                msg.sender,                // the caller should be the spender
                approvalAmount,
                deadline,
                v,
                r,
                s
        );

        // conduct the transfer
        transferFrom(from, to, amount);
    }
}

