## 실습 1

### Foundry 문서

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

### 빌드

```shell
$ forge build
```

### 테스트 (테스트 코드 실행)

이번 테스트 코드는 제가 직접 짰습니다.

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### 배포

```shell
$ forge script script/Hello.s.sol:HelloScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Etherscan에 컨트랙트 증명 (verification)

```shell
$ forge verify-contract \
    --chain-id 11155111 \
    --num-of-optimizations 200 \
    --watch \
    --etherscan-api-key <etherscan-api-key> \
    --compiler-version v0.8.13+commit.abaa5c0e \
    <deployed-to-address> \
    src/Hello.sol:Hello
```
