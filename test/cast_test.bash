tokenAddress=""
pool=""
contractAddress=""
ownerAddress=""
privateKey=""
keeperAddress=""
keeperPrvKey=""
rpcUrl="localhost:8545"


ehco 'make approve for token ' $tokenAddress
cast send $tokenAddress "approve(address,uint256)" $contractAddress 100000000000000000 --private-key $privateKey --rpc-url $rpcUrl

echo 'check allowance for ' $ownerAddress 'to ' $contractAddress
cast call $tokenAddress "allowance(address,address)(uint256)" $ownerAddress $contractAddress --rpc-url $rpcUrl

echo 'check balance for ' $ownerAddress
cast call $pool "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" $contractAddress --rpc-url $rpcUrl

echo 'make deposit into vault '
cast send $contractAddress "deposit(address,uint256,uint16)" $tokenAddress 1000000 0 --private-key $privateKey --rpc-url $rpcUrl

echo 'check balances for ' $contractAddress
cast call $pool "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" $contractAddress --rpc-url $rpcUrl

echo 'check balances for ' $ownerAddress
cast call $pool "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" $ownerAddress --rpc-url $rpcUrl

echo 'check health factor for ' $contractAddress
cast call $contractAddress "getVaultHealthFactor()(uint256)" --rpc-url $rpcUrl

echo 'require rebalance for ' $contractAddress
cast call $contractAddress "requireRebalance()(bool)" --rpc-url $rpcUrl

echo 'require notification for ' $contractAddress
cast call $contractAddress "requireNotification()(bool)" --rpc-url $rpcUrl

echo 'check rebalance threshold for ' $contractAddress
cast call $contractAddress "REBALANCE_THRESHOLD()(uint256)" --rpc-url $rpcUrl

echo 'borrow token ' $tokenAddress
cast send $contractAddress "borrow(address, uint256, uint256, uint16)" $tokenAddress 100000 2 0 --private-key $privateKey --rpc-url $rpcUrl

echo 'get vault data ' $contractAddress
cast call $contractAddress "getVaultAccountData()(uint256,uint256,uint256,uint256,uint256,uint256)" --rpc-url $rpcUrl

echo 'make repay for token ' $tokenAddress
cast send $contractAddress "repay(address, uint256, uint256)" $tokenAddress 100000 2 --private-key $privateKey --rpc-url $rpcUrl

echo 'withdraw money in token ' $tokenAddress
cast send $contractAddress "withdraw(address,uint256,address)" $tokenAddress 1000000 $ownerAddress --private-key $privateKey --rpc-url $rpcUrl

echo 'check balances for ' $contractAddress ' token ' $tokenAddress
cast call $tokenAddress "balanceOf(address)(uint256)" $ownerAddress --rpc-url $rpcUrl

echo 'set keeper for ' $contractAddress
cast send $contractAddress "setKeeper(address)" $keeperAddress --private-key $privateKey --rpc-url $rpcUrl

cast send $contractAddress "depositByKeeper(address,uint256,uint16)" $tokenAddress 1000000 0 --private-key $keeperPrvKey --rpc-url $rpcUrl

cast send $contractAddress "rebalance(address[],uint256[])" "[$tokenAddress]" "[1000000]" --private-key $keeperPrvKey --rpc-url $rpcUrl
