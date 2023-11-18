tokenAddress="0xaf88d065e77c8cC2239327C5EDb3A432268e5831"
pool="0x794a61358D6845594F94dc1DB02A252b5b4814aD"
contractAddress="0xb5d5DDd0343372eBdBb70521139783FCFF6e2Ea2"
ownerAddress="0x0D37daA896262ab9e062d4fF792c1395891d83C9"
privateKey=""
rpcUrl="localhost:8545"


cast send $tokenAddress "approve(address,uint256)" $contractAddress 100000000000 --private-key 3dfc7036eeefc66a1760f836676e94a8c56577ee03c4eb5c5ffed7d8aa4a821d --rpc-url $rpcUrl
cast call $tokenAddress "allowance(address,address)(uint256)" $ownerAddress $contractAddress --rpc-url $rpcUrl
cast send $contractAddress "deposit(address,uint256,uint16)" $tokenAddress 100000 0 --private-key 3dfc7036eeefc66a1760f836676e94a8c56577ee03c4eb5c5ffed7d8aa4a821d --rpc-url $rpcUrl
cast call $pool "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" $contractAddress --rpc-url $rpcUrl
cast call $pool "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" $ownerAddress --rpc-url $rpcUrl
cast send $contractAddress "withdraw(address,uint256,address)" $tokenAddress 10000 $ownerAddress --private-key 3dfc7036eeefc66a1760f836676e94a8c56577ee03c4eb5c5ffed7d8aa4a821d --rpc-url $rpcUrl
cast call $tokenAddress "balanceOf(address)(uint256)" $ownerAddress --rpc-url $rpcUrl
