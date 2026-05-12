// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

contract FundState {
    enum State {
        Active,
        Paused,
        Success,
        Failure
    }

    State public state;

    modifier onlyActive() {
        require(state == State.Active, "Fund is not active");
        _;
    }
}