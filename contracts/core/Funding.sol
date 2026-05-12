// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../base/FundState.sol";
import "../interfaces/IFunding.sol";

contract Funding is UUPSUpgradeable, OwnableUpgradeable, IFunding, FundState {

    uint256 private constant MIN_FUNDING_AMOUNT = 1 ether;
    uint256 private constant MAX_FUNDING_AMOUNT = 10 ether;
    mapping(address -> uint256) private _funds;
    

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        state = State.Active;
    }

    // 核心逻辑：用户打款
    function fund() public payable override onlyActive{
        require(msg.value > 0, "No ETH sent");
        emit Funded(msg.sender, msg.value, block.timestamp);
    }

    // UUPS必须实现
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}