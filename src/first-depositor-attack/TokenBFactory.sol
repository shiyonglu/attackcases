// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {TokenB} from "./TokenB.sol";

contract TokenBFactory {
    

    function deployTokenB(address assetToken) public returns (TokenB tokenB){
            return new TokenB(IERC20(assetToken));
    }
}
 
