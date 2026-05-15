// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

contract FundAccess { 

    uint256 private START_TIME;
    uint256 private constant DURATION = 1 seconds;

    modifier onlyDuringFunding() {
        require(block.timestamp >= START_TIME + DURATION, "Funding is not yet over");
        _;
    }

    modifier onlyNotDuringFunding() {
        require(block.timestamp < START_TIME + DURATION, "Funding is over");
        _;
    }

    function __FundAccess_init() internal {
        START_TIME = block.timestamp;
    }

}