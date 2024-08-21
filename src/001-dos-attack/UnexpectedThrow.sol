// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract President {
    address public president;
    uint256 public price;

    constructor() {
        president = msg.sender;
        price = 1 ether;
    }

    function becomePresident() public payable {
        require(msg.value >= price, "Insufficient payment");

        // Transfer the price to the current president
        (bool sent,) = payable(president).call{value: price}("");
        require(sent, "Payment to current president failed");

        // Update president and price
        president = msg.sender;
        price = price * 2;
    }
}
