// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/GuardFactory.sol";
import "src/LendGuard.sol";

contract FactoryTest is Test {
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

    function test_deployGuard() public {
        assertEq(LendGuard(guard).owner(), user, "!owner missmatch");
        assertEq(LendGuard(guard).KEEPER(), keeper, "!keeper missmatch");
        assertTrue(LendGuard(guard).initialized(), "!initialzed");
    }

    function test_getHealthFactor() public view {
        uint256 healthFactor = LendGuard(guard).getVaultHealthFactor();
        console.log("healthFactor", healthFactor);
    }

    function test_changeKeeper() public {
        address newKeeper = vm.addr(3);
        vm.prank(user);
        LendGuard(guard).setKeeper(newKeeper);
        assertEq(LendGuard(guard).KEEPER(), newKeeper, "!keeper missmatch");
    }
}
