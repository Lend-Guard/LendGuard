// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "src/LendGuard.sol";

contract LendGuardDeployScript is Script {
    function setUp() public {}

    function run() external {
        uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);

        LendGuard guard = new LendGuard();
        console2.log("LendGuard deployed at:", address(guard));

        vm.stopBroadcast();
    }
}
