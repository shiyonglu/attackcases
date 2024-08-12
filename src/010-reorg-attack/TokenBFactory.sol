// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {TokenB} from "./TokenB.sol";




contract TokenBFactory {
 
    function deployTokenB(address assetToken, bytes32 _salt) public returns (TokenB tokenB){
              tokenB = new TokenB{salt: _salt}(IERC20(assetToken));

              // fix the vulnerablity of reorg attack like this: 
              // bytes32 newSalt = keccak256(abi.encodePacked(_salt, abi.encode(msg.sender)));
              // tokenB = new TokenB{salt: newSalt}(IERC20(assetToken));

              tokenB.transferOwnership(msg.sender);
    }
}
 
