// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "src/LendGuard.sol";
import "src/GuardFactory.sol";

contract LendGuardDeployScript is Script {
    address public implementaion;
    address public factory;
    address public guard;

    address public lendingPool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD; // Aave Mainnet Lending Pool
    address public keeper = 0xbB4F0C2c6A180DD8F3D86f52c5989429a727708E;

    function setUp() public {}

    function run() external {
        uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);

        implementaion = address(new LendGuard(lendingPool));
        console2.log("implementation", implementaion);

        factory = address(
            new GuardFactory(
            implementaion,
            keeper
            )
        );
        console2.log("factory", factory);

        vm.stopBroadcast();
    }
}
