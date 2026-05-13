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

    modifier onlyPaused() {
        require(state == State.Paused, "Fund is not paused");
        _;
    }

    modifier onlySuccess() {
        require(state == State.Success, "Fund is not successful");
        _;
    }

    modifier onlyFailure() {
        require(state == State.Failure, "Fund is not failed");
        _;
    }


}