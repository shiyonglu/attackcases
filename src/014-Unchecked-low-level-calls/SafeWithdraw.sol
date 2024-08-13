// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeWithdraw {
    mapping(address => uint256) public balances;
    uint256 public etherLeft;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        etherLeft += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        etherLeft -= _amount;
        // Check the return value of send()
        bool success = payable(msg.sender).send(_amount);
        require(success, "Transfer failed");
    }
}
