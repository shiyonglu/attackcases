
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract PPSwap is ERC20{
    constructor() ERC20("PPSwap", "PPS"){
        _mint(msg.sender, 1_000_000_000 ether);
    }    
}
