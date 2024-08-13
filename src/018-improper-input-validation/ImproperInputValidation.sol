// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnsafeBank {
    mapping(address => uint256) public balances;

    // Allow depositing on other's behalf
    function deposit(address _for) public payable {
        balances[_for] += msg.value;
    }

    // Function to withdraw funds from an arbitrary account
    function withdraw(address from, uint256 amount) public {
        // Check if the 'from' address has enough balance
        require(balances[from] >= amount, "Insufficient balance");

        // Missing validation: the contract does not check if the caller (msg.sender) is authorized to withdraw from the 'from' address
        balances[from] -= amount;

        // Transfer the amount to the caller (msg.sender)
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
