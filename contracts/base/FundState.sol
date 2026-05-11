// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

contract FundState {
    enum State {
        Active,
        Paused,
        Success,
        Failure
    }

    modifier onlyActive() {
        require(State == State.Active, "Fund is not active");
        _;
    }
}