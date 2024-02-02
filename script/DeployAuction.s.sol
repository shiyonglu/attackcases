/*
 *  Command: 
 *  1.  simulate locally
 *        forge script script/Aution.s.sol
 *  2. simulate remotely 
 *      forge script script/Auction.s.sol --rpc-url $POLYGON_RPC_URL
 * 
 *      $POLYGON_RPC_URL is obtained from https://www.alchemy.com/ (or https://www.infura.io/) and cofigured at ~/.bashrc
 * 
 *  3. deploy in real 
 *     forge script script/Auction.s.sol --rpc-url $POLYGON_RPC_URL --broadcast
 *     for example: forge script script/Auction.s.sol --rpc-url https://polygon-rpc.com --broadcast
 *  
 *  4. deploy and verify the contract
 *      forge script script/Auction.s.sol --rpc-url $POLYGON_RPC_URL --broadcast --verify src/dos-attack/Auction.sol:Auction --etherscan-api-key $POLYSCAN_API_KEY
 *   
 *  5. Just verify after deployment: 
 *     forge verify-contract --verifier-url https://api.polygonscan.com/api/ <contract-address> src/dos-attack/Auction.sol:Auction --etherscan-api-key $POLYSCAN_API_KEY
 */


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {Auction} from "../src/dos-attack/Auction.sol";

contract DeployTokenAScript is Script {
    function setUp() public {}

    function run() public { // need to write code here to deploy a contract
        uint privateKey = vm.envUint("JOHN_PRIV"); // the private key of john, .bashrc
        address john = vm.addr(privateKey);      // the wallet address of john
        console2.log("john address:", john);

        vm.startBroadcast(privateKey);     //need to tell foundry to use this private key
        // deploy a contract by john as the deployer
        Auction auction = new Auction();

        console2.log("Contract deployed at address:", address(auction));

        vm.stopBroadcast();
    }
}
