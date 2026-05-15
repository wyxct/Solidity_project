// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

interface IFunding {
    event Funded(address indexed sender, uint256 amount, uint256 timestamp);
    event ReFunded(address indexed sender, uint256 amount, uint256 timestamp);
    event Distribute(address indexed Addr, uint256 amount, uint256 timestamp);

    function fund() external payable;
    function refund() external;
    function setDistributeList(address[] calldata _list, uint256[] calldata _Amount) external;
    function distribute() external;
}