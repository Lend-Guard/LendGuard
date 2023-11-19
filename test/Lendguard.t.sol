// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {LendGuard} from "../src/LendGuard.sol";
import {GuardFactory} from "../src/GuardFactory.sol";

contract LendGuardTest is Test {
    address public keeper;
    address public user;
    address public implementaion;
    address public factory;
    address public guard;

    uint256 public threshold = 1200000000000000000;
    address public lendingPool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;

    function setUp() public {
        keeper = vm.addr(1);
        user = vm.addr(2);

        implementaion = address(new LendGuard(lendingPool));
        console.log("implementation", implementaion);

        factory = address(
            new GuardFactory(
            implementaion,
            keeper
            )
        );
        console.log("factory", factory);

        vm.prank(user);
        guard = GuardFactory(factory).createLendGuard(threshold, threshold, threshold);
        console.log("guard", guard);
    }

    function test_updateNotificationThreshold() public {
        vm.prank(user);
        LendGuard(guard).updateNotificationThreshold(1100000000000000000);
        assertEq(LendGuard(guard).NOTIFICATION_THRESHOLD(), 1100000000000000000);
    }

    function test_updateRebalanceThreshold() public {
        vm.prank(user);
        LendGuard(guard).updateRebalanceThreshold(1100000000000000000);
        assertEq(LendGuard(guard).REBALANCE_THRESHOLD(), 1100000000000000000);
    }

    function test_updateTargetHealthFactor() public {
        vm.prank(user);
        LendGuard(guard).updateTargetHealthFactor(1100000000000000000);
        assertEq(LendGuard(guard).TARGET_HEALTH_FACTOR(), 1100000000000000000);
    }

    function test_Keeper() public {
        vm.prank(user);
        LendGuard(guard).setKeeper(address(0x3F56e0c36d275367b8C502090EDF38289b3dEa0d));
        assertEq(LendGuard(guard).KEEPER(), address(0x3F56e0c36d275367b8C502090EDF38289b3dEa0d));
    }
}
