// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {LendGuard} from "../src/LendGuard.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console.sol";


contract LendGuardTest is Test {
    LendGuard public lendGuard;
    address public testToken;

    function setUp() public {
        lendGuard = new LendGuard();
        testToken = 0x3F56e0c36d275367b8C502090EDF38289b3dEa0d;
    }

    function test_updateNotificationThreshold() public {
        lendGuard.updateNotificationThreshold(1100000000000000000);
        assertEq(lendGuard.NOTIFICATION_THRESHOLD(), 1100000000000000000);
    }

    function test_updateRebalanceThreshold() public {
        lendGuard.updateRebalanceThreshold(1100000000000000000);
        assertEq(lendGuard.REBALANCE_THRESHOLD(), 1100000000000000000);
    }

    function test_updateTargetHealthFactor() public {
        lendGuard.updateTargetHealthFactor(1100000000000000000);
        assertEq(lendGuard.TARGET_HEALTH_FACTOR(), 1100000000000000000);
    }

    function test_Keeper() public {
        lendGuard.setKeeper(address(0x3F56e0c36d275367b8C502090EDF38289b3dEa0d));
        assertEq(lendGuard.KEEPER(), address(0x3F56e0c36d275367b8C502090EDF38289b3dEa0d));
    }
}

