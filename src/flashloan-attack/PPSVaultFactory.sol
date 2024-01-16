
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {PPSVault} from "./PPSVault.sol";




contract PPSVaultFactory {
 
    function deployPPSVault(address assetToken, bytes32 _salt) public returns (PPSVault ppsVault){
              bytes32 newSalt = keccak256(abi.encodePacked(_salt, abi.encode(msg.sender)));

              ppsVault = new PPSVault{salt: newSalt}(IERC20(assetToken));
              ppsVault.transferOwnership(msg.sender);
    }
}
 
