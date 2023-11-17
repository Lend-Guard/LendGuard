// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import ownable
import "@openzeppelin/contracts/access/Ownable.sol";

contract LendGuard is Ownable {

    constructor(address initialOwner) Ownable(initialOwner){}

    function getHello() public returns (string memory) {
        return "Hello";
    }
}
