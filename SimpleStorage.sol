// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint public value;

    function increment() public {
        value += 1;
    }

    function decrement() public {
        require(value > 0, "Value cannot be negative");
        value -= 1;
    }
}