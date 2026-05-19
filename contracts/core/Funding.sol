// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "../base/FundState.sol";
import "../base/FundAccess.sol";
import "../interfaces/IFunding.sol";
import "../libraries/AddressUtils.sol";
import "../libraries/FundingMath.sol";

contract Funding is UUPSUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable, IFunding, FundState, FundAccess {

    using AddressUtils for address payable;
    using FundingMath for uint256;

    uint256 private constant MIN_FUNDING_AMOUNT = 1 ether;
    uint256 private constant MAX_FUNDING_AMOUNT = 10 ether;
    uint256 private constant distributeDecimal = 100;
    uint256 private constant distributeAmount = 100 ether;
    uint256 private balance;
    mapping(address => uint256) private _funds;
    address[] private distributeReceivers;
    uint256[] private distributePercentages;


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();
        __FundAccess_init();
        state = State.Active;
    }

    // 核心逻辑：用户打款
    function fund() public payable override onlyActive onlyDuringFunding{
        require(msg.value.isWithinLimit(MIN_FUNDING_AMOUNT, MAX_FUNDING_AMOUNT), "Funding amount exceeds limit");
        require(msg.value.isEnough(distributeAmount, balance), "Past fund enough balance");
        _funds[msg.sender] += msg.value;
        balance += msg.value;
        if (balance == distributeAmount){
            state = State.Success;
        }
        emit Funded(msg.sender, msg.value, block.timestamp);
    }

    function refund() public nonReentrant onlyActive onlyDuringFunding{
        uint256 amount = _funds[msg.sender];
        require(amount > 0, "No fund to refund");
        _funds[msg.sender] = 0;
        balance -= amount;
        payable(msg.sender).safeTransferETH(amount);
        emit ReFunded(msg.sender, amount, block.timestamp);
    }

    function setDistributeList(address[] calldata _distributeAddress, uint256[] calldata _distributeAmount) public onlyOwner onlyActive{
        require(_distributeAddress.length == _distributeAmount.length, "distributeAddress length not equal distributeAmount length");
        uint256 total;
        for(uint256 i = 0; i < _distributeAddress.length; i++){
            total += _distributeAmount[i];
        }
        require(total == 100, "Total must be 100%");
        distributeReceivers = _distributeAddress;
        distributePercentages = _distributeAmount;
    }

    function distribute() public onlyOwner nonReentrant onlyActive onlySuccess onlyNotDuringFunding{
        require(balance > 0, "has no balance");
        uint256 totalAmount = balance;
        for(uint256 i = 0; i < distributeReceivers.length; i++){
            address payable dst = payable(distributeReceivers[i]);
            balance -= totalAmount * distributePercentages[i] / distributeDecimal;
            dst.safeTransferETH(totalAmount * distributePercentages[i] / distributeDecimal);
            emit Distribute(distributeReceivers[i], totalAmount * distributePercentages[i] / distributeDecimal, block.timestamp);
        }
    }

    // UUPS必须实现
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}