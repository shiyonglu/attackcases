pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol"; // Importing Ownable for access control
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Distribution  is ReentrancyGuard, Ownable {

    ERC721Enumerable public nftContract;

    mapping(address => bool) public walletHasClaimedSnapshot;
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
        // @dev - should we add locking (?)
        nftContract = ERC721Enumerable(_nftContract);
    }

    function setMutiSignatureWallet(address _multiSigWallet) external onlyOwner {
        // @dev - Prevents contract deployer from modifying the multisignatture wallet later on and
        // withdrawing the crypto to it instead of the original multisignature wallet.
        require(contractIsLocked == false, "Contract is locked.");
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
        uint256 totalSupply = nftContract.totalSupply();
        require(totalSupply > 0, "No NFTs found in the contract.");
        uint256 userNFTBalance = nftContract.balanceOf(msg.sender);
        require(userNFTBalance > 0, "User balance of NFT is zero.");

        // Temporary override for testing
        // if (totalAmountOverride > 0) {
        //     totalSupply = totalAmountOverride;
        // }
        
        // Calculate amount owed to user
        // uint256 userShare = (address(this).balance) * userNFTBalance / totalSupply;
        uint256 userShare = originalBalance * userNFTBalance / totalSupply;
        require(userShare > 0, "User share is zero.");

        // Verify merkle proof
        // @dev Set to msg.sender instead of tx.origin to enable smart contract accounts
        // as opposed to only EOA accounts
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof.");

        (bool sent, ) = msg.sender.call{value: userShare}("");
        require(sent, "Failed to send Ether");

        // Prevents multiple claims from being made
        walletHasClaimedSnapshot[msg.sender] = true;
        userAgreements[msg.sender] = _userAgreement;
        
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
