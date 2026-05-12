// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library FundingMath {
    
    function isExpired(uint256 deadline) internal view returns (bool) {
        return block.timestamp >= deadline;
    }

    function isEnough(uint256 amount, uint256 balance) internal pure returns (bool) {
        return amount <= balance;
    }

    function isWithinLimit(uint256 amount, uint256 min, uint256 max) internal pure returns (bool) {
        return amount <= max && amount >= min;
    }
}