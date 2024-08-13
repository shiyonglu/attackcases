// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MixedAccounting {
    uint256 myBalance;

    function deposit() public payable {
        myBalance = myBalance + msg.value;
    }

    function myBalanceIntrospect() public view returns (uint256) {
        return address(this).balance;
    }

    function myBalanceVariable() public view returns (uint256) {
        return myBalance;
    }

    function notAlwaysTrue() public view returns (bool) {
        return myBalanceIntrospect() == myBalanceVariable();
    }
}
