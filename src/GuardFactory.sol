// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./LendGuard.sol";

contract GuardFactory is Ownable {
    address public guardImplementation;
    address public defaultKeeper;

    mapping(address => address) internal _guards;

    /**
     * @notice Constructor
     * @param _implementation The implementation of the LendGuard contract
     * @param _defaultKeeper The default keeper address
     */
    constructor(address _implementation, address _defaultKeeper) Ownable(msg.sender) {
        guardImplementation = _implementation;
        defaultKeeper = _defaultKeeper;
    }

    /**
     * @notice Change the implementation of the LendGuard contract
     * @param newImplementation The new implementation address
     */
    function changeImplementation(address newImplementation) external onlyOwner {
        guardImplementation = newImplementation;
    }

    /**
     * @notice Change the default keeper address
     * @param newKeeper The new keeper address
     */
    function changeDefaultKeeper(address newKeeper) external onlyOwner {
        defaultKeeper = newKeeper;
    }

    /**
     * @notice Create a new LendGuard contract clone
     * @param notificationThreshold The notification threshold
     * @param rebalanceThreshold The rebalance threshold
     * @param targetHealthFactor The target health factor
     */
    function createLendGuard(uint256 notificationThreshold, uint256 rebalanceThreshold, uint256 targetHealthFactor)
        external
        returns (address guard)
    {
        guard = Clones.clone(guardImplementation);

        LendGuard(guard).initialize(
            notificationThreshold, rebalanceThreshold, targetHealthFactor, msg.sender, defaultKeeper
        );

        _guards[msg.sender] = guard;
    }

    /**
    * @notice Get the LendGuard contract address for a user
    * @param user The user address
    */
    function getUserGuard(address user) external view returns (address) {
        return _guards[user];
    }
}
