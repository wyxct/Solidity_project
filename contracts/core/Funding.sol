// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Funding is UUPSUpgradeable, OwnableUpgradeable {
    // 核心事件：Go监听这个就行
    event Funded(address indexed sender, uint256 amount, uint256 timestamp);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    // 核心逻辑：用户打款
    function fund() public payable {
        require(msg.value > 0, "No ETH sent");
        emit Funded(msg.sender, msg.value, block.timestamp);
    }

    // UUPS必须实现
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}