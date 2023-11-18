// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol";

contract LendGuard {
    // Owner of the contract
    address private _owner;

    L2Pool public pool;
    address public POOL_ADDRESS = 0x794a61358D6845594F94dc1DB02A252b5b4814aD; // Arbitrum L2 Aave pool

    // LendGuard keeper
    address internal KEEPER;

    // Check if keeper is initialized
    modifier onlyKeeper() {
        require(msg.sender == KEEPER, "only keeper");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner(), "only owner");
        _;
    }

    /**
     * @notice Modifier to check if the caller is the owner or the keeper
     * @dev It is used for rebalancer functions
     *
     */
    modifier multipleAccess() {
        require(msg.sender == KEEPER || msg.sender == owner(), "only keeper or owner");
        _;
    }

    constructor() {
        pool = L2Pool(POOL_ADDRESS);
        _owner = msg.sender;
    }

    /**
     * @notice Returns the address of the owner
     * @return The address of the owner
     *
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @notice Returns the health factor of the user. The health factor is returned on a scale of 1e18.
     * A healt factor of 1e18 means the position is healthy, and decreases from there.
     * @param user The address of the user
     * @return The health factor of the user
     *
     */
    function getUserHealtFactor(address user) public view returns (uint256) {
        uint256 healthFactor;
        (,,,,, healthFactor) = pool.getUserAccountData(user);
        return healthFactor;
    }

    /**
     * @notice Returns the health factor of the reserve. The health factor is returned on a scale of 1e18.
     * A healt factor of 1e18 means the position is healthy, and decreases from there.
     * @return The health factor of the reserve
     *
     */
    function getVaultHealthFactor() public view returns (uint256) {
        return getUserHealtFactor(address(this));
    }

    function setKeeper(address keeper) external onlyOwner {
        KEEPER = keeper;
    }

    /**
     * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
     * - E.g. User supplies 100 USDC and gets in return 100 aUSDC
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function deposit(address asset, uint256 amount, uint16 referralCode) external multipleAccess {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        pool.deposit(asset, amount, address(this), referralCode);
    }

    /**
     * @notice Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
     * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
     * @param asset The address of the underlying asset to withdraw
     * @param amount The underlying amount to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
     * @param to The address that will receive the underlying, same as msg.sender if the user
     *   wants to receive it on his own wallet, or a different address if the beneficiary is a
     *   different wallet
     * @return The final amount withdrawn
     */
    function withdraw(address asset, uint256 amount, address to) external onlyOwner returns (uint256) {
        uint256 amount = pool.withdraw(asset, amount, address(this));
        IERC20(asset).transfer(to, amount);
        return amount;
    }

    /**
     * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
     * already supplied enough collateral, or he was given enough allowance by a credit delegator on the
     * corresponding debt token (StableDebtToken or VariableDebtToken)
     * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
     *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
     * @param asset The address of the underlying asset to borrow
     * @param amount The amount to be borrowed
     * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
     * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     */
    function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf)
        external
        onlyOwner
    {
        pool.borrow(asset, amount, interestRateMode, referralCode, address(this));
    }

    /**
     * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
     * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @param onBehalfOf The address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @return The final amount repaid
     */
    function repay(address asset, uint256 amount, uint256 interestRateMode, address onBehalfOf)
        external
        multipleAccess
        returns (uint256)
    {
        return pool.repay(asset, amount, interestRateMode, onBehalfOf);
    }
}
