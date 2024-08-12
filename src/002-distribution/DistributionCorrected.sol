pragma solidity ^0.8.0;
 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing Ownable for access control
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/* 
Changes made: 
 
1. setNFTContract(): add ``require(contractIsLocked == false, "Contract is locked.");`` so that once the contract is locked, this method is disabled. 
2. setMutiSignatureWallet(): zero address check is added
3. total supply for WSC NFT is harded coded to prevent future minting disturbance: uint256 totalSupply = 3334
4. NFTHasClaimed mapping is added with the correponsing code, so that each NFT can claim at most once. 
5. Add the NFT Id check so that ID >= 3334 cannot claim
6. Move "walletHasClaimedSnapshot[msg.sender] = true;
        userAgreements[msg.sender] = _userAgreement;" before the sending of ETH to follow good practice.
*/

 
import {Test, console2} from "forge-std/Test.sol";
 
 
/**
 * @title SnapshotMerkleDistribution
 * @dev General use of tx.origin was to prevent gaming through use of intermediary smart
 * contract but use of Merkle Proofs allows us to ignore that attack vector.
 */
contract SnapshotMerkleDistribution  is ReentrancyGuard, Ownable {
 
    ERC721Enumerable public nftContract;
 
    mapping(address => bool) public walletHasClaimedSnapshot;
    mapping(uint256 => bool) public NFTHasClaimed;
    mapping(address => string) public userAgreements;
 
    bool public isRefundActive = false;
    bool public contractIsLocked = false;
    bool public lockedInPerpetuity = false;
    address public multisignatureWallet;
 
    // @dev Provides us with a snapshot of the wallets that are eligible for refund
    // @see https://medium.com/@ItsCuzzo/using-merkle-trees-for-nft-whitelists-523b58ada3f9
    bytes32 public merkleRoot;
    // @dev Ensures individual refund amount remains static even after claim process begins
    uint256 public originalBalance;
    // Temporary
    // uint16 public totalAmountOverride;
 
    constructor() Ownable(msg.sender) {}
 
    // @dev Necessary to allow us to retrieve the total supply of NFTs and 
    // amount owned by a specific wallet
    function setNFTContract(address _nftContract) external onlyOwner {
        require(_nftContract != address(0), "Invalid address.");
        require(contractIsLocked == false, "Contract is locked.");
        // @dev - should we add locking (?)
        nftContract = ERC721Enumerable(_nftContract);
    }
 
    function setMutiSignatureWallet(address _multiSigWallet) external onlyOwner {
        // @dev - Prevents contract deployer from modifying the multisignatture wallet later on and
        // withdrawing the crypto to it instead of the original multisignature wallet.
        require(contractIsLocked == false, "Contract is locked.");
        require(multisignatureWallet != address(0), "Invalid address.");
        multisignatureWallet = _multiSigWallet;
    }
 
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        // @dev - Prevents contract deployer from uploading a merkle root hash representing a different
        // snapshot and authorizing a different set of wallets to claim the refund.
        require(contractIsLocked == false, "Contract is locked.");
        merkleRoot = _merkleRoot;
    }    
 
    // @dev Allows us to ensure that the amount returned to each wallet remains fixed throughout the 
    // whole liquidation process.
    function saveOriginalBalance() external onlyOwner() {
        // @dev - Prevents contract deployer from changing the original balance later on in order to reduce
        // the amount of funds returned to the users.
        require(contractIsLocked == false, "Contract is locked.");
        originalBalance = address(this).balance;
    }
 
    // @dev Activates refund
    function activate() external onlyOwner() {
        isRefundActive = true;
    }
 
    // @dev Deactivates refund
    function deactivate() external onlyOwner() {
        require(contractIsLocked == false, "Contract is locked.");
        isRefundActive = false;
    }
 
    // @dev Irreversible action - Contract lock prevents modification of 1- emergency 
    // multisignature wallet and merkle root change, which cements the snapshot forever.
    function lockContract() external onlyOwner() {
        contractIsLocked = true;
    }
 
    // @dev Irreversible action - Locks the contract in perpetuity, preventing any emergency
    // withdrawal.
    function lockInPerpetuity() external onlyOwner() {
        lockedInPerpetuity = true;
    }
 
    // @dev Sanity function in case something deeply wrong happens - allows the funds to be sent
    // to the multisignature wallet, thus protecting the funds from being lost. 
    function emergencyWithdrawalToMultiSignature() external onlyOwner {
        // @dev - lockedInPerpetuity allows funds to remain in claim process forever.
        require(lockedInPerpetuity == false, "Contract is locked in perpetuity.");
        uint256 balance = address(this).balance;
        require(multisignatureWallet != address(0), "Multi signature wallet not set.");
        (bool sent, ) = multisignatureWallet.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }
 
    /** Dev Temporary Functions */
 
    // @dev Will be removed in production.
    // function unlockContract() external onlyOwner() {
    //     contractIsLocked = false;
    // }
 
    // function setTotalAmountOverride(uint16 _totalAmount) external onlyOwner {
    //     require(contractIsLocked == false, "Contract is locked.");
    //     totalAmountOverride = _totalAmount;
    // }
 
    receive() external payable {}
 
    // Allows us to test the structure based on @setSnapshotOfWalletsWithoutTokenCount
    function goToValhalla(string memory _userAgreement, bytes32[] calldata _merkleProof) external nonReentrant {
 
        require(isRefundActive, "Refund is not active.");
        require(address(this).balance > 0, "Contract balance is zero.");
        require(walletHasClaimedSnapshot[msg.sender] == false, "You have already claimed your ETH.");
        require(originalBalance > 0, "Original balance is zero.");
 
        // Helps calculate the share of user
        uint256 totalSupply = 3334; // hard coded so that future minting will not change the denominator
 
        uint256 userNFTBalance = nftContract.balanceOf(msg.sender);
        require(userNFTBalance > 0, "User balance of NFT is zero.");
 
         // iterarate through NFTs of msg.sender and identify the unclaimed ones
        uint256 unclaimedNFTBalance;
        for(uint256 i; i < userNFTBalance; i++){
            uint nftId = nftContract.tokenOfOwnerByIndex(msg.sender, i);
            if(NFTHasClaimed[nftId] || nftId >= 3334) continue; // this NFT has already claimed or greater than current max ID
 
            unclaimedNFTBalance++;
            NFTHasClaimed[nftId] = true;       // mark this NFT has claimed it
        }
 
 
        require(unclaimedNFTBalance > 0, "User balance of NFT is zero.");
 
        // Calculate amount owed to user
        // uint256 userShare = (address(this).balance) * userNFTBalance / totalSupply;
        uint256 userShare = originalBalance * unclaimedNFTBalance / totalSupply;
        require(userShare > 0, "User share is zero.");
 
        // Verify merkle proof
        // @dev Set to msg.sender instead of tx.origin to enable smart contract accounts
        // as opposed to only EOA accounts
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof.");
 
         // Prevents multiple claims from being made, better to move here to following the check-effects-interaction pattern
        walletHasClaimedSnapshot[msg.sender] = true;
        userAgreements[msg.sender] = _userAgreement;
 
        (bool sent, ) = msg.sender.call{value: userShare}("");
 
        console2.log("userShares: ", userShare);
 
        require(sent, "Failed to send Ether");
 
 
 
    }
 
    // Helper Functions
    // @dev Future improvement includes potentially storing all the addresses in an array instead of just a mapping
 
    function getClaimedStatusOfWallet(address _walletAddress) external view returns (bool) {
        return walletHasClaimedSnapshot[_walletAddress];
    }
 
    function getUserAgreementOfWallet(address _walletAddress) external view returns (string memory) {
        return userAgreements[_walletAddress];
    }
 
}
 
 
