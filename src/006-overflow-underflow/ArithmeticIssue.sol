// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract ArithmeticIssue {
    mapping(address => uint256) public balances;

    // Function to deposit Ether into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] - _amount > 0, "Insufficient balance");
        balances[msg.sender] -= _amount;
        (bool success,) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
    }

    // Vulnerable withdraw function that uses `unchecked` to simulate an arithmetic issue
    function withdrawUnchecked(uint256 _amount) public {
        unchecked {
            require(balances[msg.sender] - _amount > 0, "Insufficient balance");
            balances[msg.sender] -= _amount;
            (bool success,) = payable(msg.sender).call{value: _amount}("");
            require(success, "Transfer failed");
        }
    }

    // Function to get the balance of the sender
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
