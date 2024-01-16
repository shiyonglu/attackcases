// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "./ERC4626.sol";

contract TokenB is ERC4626{
    constructor(IERC20 _asset) ERC20("TokenB", "BBB") ERC4626(_asset){

    }

    
}
 
