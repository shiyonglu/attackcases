// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShortAddressAttack {
    mapping(address => uint256) public balances;

    // Function to deposit tokens into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // More secure transfer function with a check on address length via calldata length
    function transfer(address _to, uint256 _amount) public {
        // Ensure that the length of calldata matches what is expected for this function
        require(msg.data.length == 68, "Invalid calldata length");

        // Check that the address is not the zero address
        require(_to != address(0), "Invalid address");

        // Ensure the sender has enough balance
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
