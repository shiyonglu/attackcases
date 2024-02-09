// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
 
import {Test, console2} from "forge-std/Test.sol";
 
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
 
import {Distribution} from "../../src/distribution/Distribution.sol";
 
 
interface IWSCContract{
    function unpauseGeneralSale() external;
    function mintWallStreetChadsGeneralSale(uint256 amount) external payable;
}
 
 
contract RefundTest is Test {
     Distribution dist;
     ERC721Enumerable wscContract;
 
     address user1 = 0x8Afb575c248764058778283A19C54da191dF9a9c;
     address user2 = 0x433485B5951f250cEFDCbf197Cb0F60fdBE55513; 
     address user3 = 0x90995b363aA1d40a3835B5FF17C2F8Bfb0BA8e0f; 
     address user4 = 0x055EC98eA6bA4393Df90137738390C3aBBc39CC1; 
 
     address nonClaimer = makeAddr("nonClaimer");
     address wscOwner = 0x7A7F0f09eAdbBb07f9794497a4B5AE332688CF69;
 
 
    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("https://mainnet.infura.io/v3/95310f60af7b44bb8f3b13c043a00c8f"));
 
        dist = new Distribution();
        wscContract = ERC721Enumerable(0xf341eD41475fedD4704902B4b82F1D2EB4D477E8);
        dist.setNFTContract(address(wscContract));
        dist.setMerkleRoot(bytes32(0xe501d7720ab8584daa9415cf7d61dc5f35d9932448ccb5e6f6913f7f0952520e));
 
 
        deal(address(dist), 3334 ether);
        dist.saveOriginalBalance();
        dist.activate();
 
         deal(user1, 10 ether);
 
    }
 
 
 
    function testSetContract() public{
        vm.startPrank(user1);
        vm.expectRevert();
        dist.setNFTContract(address(0x1234));
        vm.stopPrank();
 
        dist.setNFTContract(address(0x1234));
        vm.expectRevert();
        dist.setNFTContract(address(0x0));
    }
 
     // These users have 1, 2, 3, 4 NFTs
    function testTotal() public view{
        console2.log("user1 balance: ", wscContract.balanceOf(user1));
        console2.log("user2 balance: ", wscContract.balanceOf(user2));
        console2.log("user3 balance: ", wscContract.balanceOf(user3));
        console2.log("user4 balance: ", wscContract.balanceOf(user4));        
    }
 
    // The same user can claim at most once
    function testRefund1() public{
 
        bytes32[] memory proof1 = new  bytes32[](11);
        proof1[0] = bytes32(0x6c1a462a428d38b4d97328446c65bf7e2e1a976ede92cf301d2a6432316fd275);
        proof1[1] = bytes32(0x29326863569250f11a0a827e92cd014f2f8cd1c2400a133d86a18db13d9f49eb);
        proof1[2] = bytes32(0xd2e9482802fa449dbade9b6a25ac4a2a7dcf4a34fc6e42454238d5ba2172f85b);
        proof1[3] = bytes32(0x918ea9d5df02282ba482cd6075f1ba9bfc19f376001bd6cd6c3373040d1a36c5);
        proof1[4] = bytes32(0xe2d726f9ddbd4f007c4ab1b2129d975f486b69eda3906788c24ac7d98b724f7a);
        proof1[5] = bytes32(0x050c70db2fcf26133e5d042dd7b5b42dc8b4a5cb45d7c17ffa2ae1d6b0f38006);
        proof1[6] = bytes32(0x194fb0d178f0733e91beba56de5aa38a419e9eed7d0fc1a38a01d5b9ca5705fa);
        proof1[7] = bytes32(0x49a4ad3dd8261e7b00e215b45599b6f6df962c7d1010b9b672124377ef5b6831);
        proof1[8] = bytes32(0x446fc5a30386d4ee7b1b8af08d6d05e18a05440916eefba4aebe1a96a22a5fa5);
        proof1[9] = bytes32(0x11a5160fc9627ed7eeb65d73263b4173006aff3599945c87dd9779458ddb527b);
        proof1[10] = bytes32(0x4ee48b9ab7a08f2d521876978d42843bc4f09f3f7b23dfd6760de072bb2edcf3);
 
 
        bytes32[] memory proof2 = new  bytes32[](11);
        proof2[0] = bytes32(0x0ec1661283d736efef04144aae52d4e9fd398481978db9f955256d3ab38309df);
        proof2[1] = bytes32(0xc6e572805255ad6a6b58a09fa65f45f933ee41d1b246791eb2c4feca4b5e0b3e);
        proof2[2] = bytes32(0x3c4308e84be9f281a73cb66271c751b97a152b7dbfaa05d2bee608f80be563a0);
        proof2[3] = bytes32(0x918ea9d5df02282ba482cd6075f1ba9bfc19f376001bd6cd6c3373040d1a36c5);
        proof2[4] = bytes32(0xe2d726f9ddbd4f007c4ab1b2129d975f486b69eda3906788c24ac7d98b724f7a);
        proof2[5] = bytes32(0x050c70db2fcf26133e5d042dd7b5b42dc8b4a5cb45d7c17ffa2ae1d6b0f38006);
        proof2[6] = bytes32(0x194fb0d178f0733e91beba56de5aa38a419e9eed7d0fc1a38a01d5b9ca5705fa);
        proof2[7] = bytes32(0x49a4ad3dd8261e7b00e215b45599b6f6df962c7d1010b9b672124377ef5b6831);
        proof2[8] = bytes32(0x446fc5a30386d4ee7b1b8af08d6d05e18a05440916eefba4aebe1a96a22a5fa5);
        proof2[9] = bytes32(0x11a5160fc9627ed7eeb65d73263b4173006aff3599945c87dd9779458ddb527b);
        proof2[10] = bytes32(0x4ee48b9ab7a08f2d521876978d42843bc4f09f3f7b23dfd6760de072bb2edcf3);
 
        uint256 preBal  = user1.balance;
        vm.prank(user1);
        dist.goToValhalla("", proof1);
        uint256 postBal = user1.balance;
        assertEq(postBal - preBal, 1 ether);
 
        // claim again
         vm.prank(user1);
         vm.expectRevert();
         dist.goToValhalla("", proof1);
 
 
    }
 
 /*
 
     // the same NFT can claim at most once 
     function testRefund2() public{ // user1 claimed but sent his NFT to user2, user2 cannnot claim the same NFT again
        bytes32[] memory proof1 = new  bytes32[](11);
        proof1[0] = bytes32(0x6c1a462a428d38b4d97328446c65bf7e2e1a976ede92cf301d2a6432316fd275);
        proof1[1] = bytes32(0x29326863569250f11a0a827e92cd014f2f8cd1c2400a133d86a18db13d9f49eb);
        proof1[2] = bytes32(0xd2e9482802fa449dbade9b6a25ac4a2a7dcf4a34fc6e42454238d5ba2172f85b);
        proof1[3] = bytes32(0x918ea9d5df02282ba482cd6075f1ba9bfc19f376001bd6cd6c3373040d1a36c5);
        proof1[4] = bytes32(0xe2d726f9ddbd4f007c4ab1b2129d975f486b69eda3906788c24ac7d98b724f7a);
        proof1[5] = bytes32(0x050c70db2fcf26133e5d042dd7b5b42dc8b4a5cb45d7c17ffa2ae1d6b0f38006);
        proof1[6] = bytes32(0x194fb0d178f0733e91beba56de5aa38a419e9eed7d0fc1a38a01d5b9ca5705fa);
        proof1[7] = bytes32(0x49a4ad3dd8261e7b00e215b45599b6f6df962c7d1010b9b672124377ef5b6831);
        proof1[8] = bytes32(0x446fc5a30386d4ee7b1b8af08d6d05e18a05440916eefba4aebe1a96a22a5fa5);
        proof1[9] = bytes32(0x11a5160fc9627ed7eeb65d73263b4173006aff3599945c87dd9779458ddb527b);
        proof1[10] = bytes32(0x4ee48b9ab7a08f2d521876978d42843bc4f09f3f7b23dfd6760de072bb2edcf3);
 
 
        bytes32[] memory proof2 = new  bytes32[](11);
        proof2[0] = bytes32(0x0ec1661283d736efef04144aae52d4e9fd398481978db9f955256d3ab38309df);
        proof2[1] = bytes32(0xc6e572805255ad6a6b58a09fa65f45f933ee41d1b246791eb2c4feca4b5e0b3e);
        proof2[2] = bytes32(0x3c4308e84be9f281a73cb66271c751b97a152b7dbfaa05d2bee608f80be563a0);
        proof2[3] = bytes32(0x918ea9d5df02282ba482cd6075f1ba9bfc19f376001bd6cd6c3373040d1a36c5);
        proof2[4] = bytes32(0xe2d726f9ddbd4f007c4ab1b2129d975f486b69eda3906788c24ac7d98b724f7a);
        proof2[5] = bytes32(0x050c70db2fcf26133e5d042dd7b5b42dc8b4a5cb45d7c17ffa2ae1d6b0f38006);
        proof2[6] = bytes32(0x194fb0d178f0733e91beba56de5aa38a419e9eed7d0fc1a38a01d5b9ca5705fa);
        proof2[7] = bytes32(0x49a4ad3dd8261e7b00e215b45599b6f6df962c7d1010b9b672124377ef5b6831);
        proof2[8] = bytes32(0x446fc5a30386d4ee7b1b8af08d6d05e18a05440916eefba4aebe1a96a22a5fa5);
        proof2[9] = bytes32(0x11a5160fc9627ed7eeb65d73263b4173006aff3599945c87dd9779458ddb527b);
        proof2[10] = bytes32(0x4ee48b9ab7a08f2d521876978d42843bc4f09f3f7b23dfd6760de072bb2edcf3);
 
 
 
        // user1 claimed
        uint256 preBal  = user1.balance;
        vm.prank(user1);
        dist.goToValhalla("", proof1);
        uint256 postBal = user1.balance;
        assertEq(postBal - preBal, 1 ether);
 
        // user1 sent his NFT to user2
        uint nftId = wscContract.tokenOfOwnerByIndex(user1, 0);
        vm.prank(user1);
        wscContract.transferFrom(user1, user2, nftId);
        console2.log("user2 balance: ", wscContract.balanceOf(user2));
 
        assertTrue(dist.NFTHasClaimed(nftId));       // claimed
 
       // although user2 have 3 NFTs, but one of them has already claimed, so he can only claim 2
        preBal  = user2.balance;
        vm.prank(user2);
        dist.goToValhalla("", proof2);
        postBal = user2.balance;
        assertEq(postBal - preBal, 2 ether);
 
        // now all the NFTS for user2 has claimed
        nftId = wscContract.tokenOfOwnerByIndex(user2, 0);  
        assertTrue(dist.NFTHasClaimed(nftId));
        nftId = wscContract.tokenOfOwnerByIndex(user2, 1);  
        assertTrue(dist.NFTHasClaimed(nftId));
        nftId = wscContract.tokenOfOwnerByIndex(user2, 2);  
        assertTrue(dist.NFTHasClaimed(nftId));
    }
 
     // address not in the snapshot cannot claim
    function testRefund3() public{
        bytes32[] memory proof2 = new  bytes32[](11);
        proof2[0] = bytes32(0x0ec1661283d736efef04144aae52d4e9fd398481978db9f955256d3ab38309df);
        proof2[1] = bytes32(0xc6e572805255ad6a6b58a09fa65f45f933ee41d1b246791eb2c4feca4b5e0b3e);
        proof2[2] = bytes32(0x3c4308e84be9f281a73cb66271c751b97a152b7dbfaa05d2bee608f80be563a0);
        proof2[3] = bytes32(0x918ea9d5df02282ba482cd6075f1ba9bfc19f376001bd6cd6c3373040d1a36c5);
        proof2[4] = bytes32(0xe2d726f9ddbd4f007c4ab1b2129d975f486b69eda3906788c24ac7d98b724f7a);
        proof2[5] = bytes32(0x050c70db2fcf26133e5d042dd7b5b42dc8b4a5cb45d7c17ffa2ae1d6b0f38006);
        proof2[6] = bytes32(0x194fb0d178f0733e91beba56de5aa38a419e9eed7d0fc1a38a01d5b9ca5705fa);
        proof2[7] = bytes32(0x49a4ad3dd8261e7b00e215b45599b6f6df962c7d1010b9b672124377ef5b6831);
        proof2[8] = bytes32(0x446fc5a30386d4ee7b1b8af08d6d05e18a05440916eefba4aebe1a96a22a5fa5);
        proof2[9] = bytes32(0x11a5160fc9627ed7eeb65d73263b4173006aff3599945c87dd9779458ddb527b);
        proof2[10] = bytes32(0x4ee48b9ab7a08f2d521876978d42843bc4f09f3f7b23dfd6760de072bb2edcf3);
 
 
        uint nftId = wscContract.tokenOfOwnerByIndex(user1, 0);
        vm.prank(user1);
        wscContract.transferFrom(user1, nonClaimer, nftId);
        console2.log("nonClaimer balance: ", wscContract.balanceOf(nonClaimer));
 
        vm.prank(nonClaimer);
        vm.expectRevert();
        dist.goToValhalla("", proof2); 
    }
 
      // Id greater than 3334 cannot claim, as a result, user1 can only claim 1 although there is a new NFT that is greater than 3334
      function testRefund4() public{
        vm.prank(wscOwner);
        IWSCContract(address(wscContract)).unpauseGeneralSale();
 
        // user1 buy one more NFT
        vm.prank(user1);
        console2.log("user1 ether balance", user1.balance);
        IWSCContract(address(wscContract)).mintWallStreetChadsGeneralSale{value: 0.08 ether}(1);
        console2.log("user1 balance: ", wscContract.balanceOf(user1));
 
        console2.log("NFT1: ", wscContract.tokenOfOwnerByIndex(user1, 0));
        console2.log("NFT2: ", wscContract.tokenOfOwnerByIndex(user1, 1));
 
 
    }
    */
}
 
