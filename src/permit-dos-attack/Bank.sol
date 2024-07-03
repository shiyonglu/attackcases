
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Bank {
    IERC20 public token;
    mapping(address => uint) public nonces;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function checkPermit(uint amount, address owner, uint deadline, uint8 v, bytes32 r, bytes32 s) public{
        bytes32 digest = keccak256(abi.encode(owner, address(this), amount, deadline, nonces[owner]++));
        address recoveredOwner = ECDSA.recover(digest, v, r, s);
        require(recoveredOwner == owner, "Invalid permit owner");
        require(block.timestamp <= deadline, "Permit expired");    
    }

    function depositWithPermit(uint amount, address owner, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
        checkPermit(amount, owner, deadline, v, r, s);
        require(token.allowance(owner, address(this)) >= amount, "Insufficient allowance");

        // Perform the deposit if the permit is valid
        token.transferFrom(owner, address(this), amount);

        // Additional logic for deposit processing
    }

    
}
