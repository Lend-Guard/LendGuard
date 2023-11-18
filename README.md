## LendGuard

**Powered by Foundry, a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

### Documentation

https://book.getfoundry.sh/

## Usage

### How to build?

```shell
forge build
```

### How to test

Interactive version:
```shell
anvil --fork-url <infura_rpc>
bash /test/cast_test.bash
```

Automated:
```shell
forge init
```

### How to deploy
```shell
EXPORT RPC_URL=<rpc>
EXPORT DEPLOYER_PRIVATE_KEY=<prvKey>
forge script script/LendGuard.s.sol:LendGuardDeployScript --rpc-url ${RPC_URL} --broadcast
```
