// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

contract FundAccess { 
    modifer onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
}