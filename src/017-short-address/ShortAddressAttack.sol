// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShortAddressAttack {
    mapping(address => uint256) public balances;

    // Function to deposit tokens into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerable transfer function that doesn't check the length of the address
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
