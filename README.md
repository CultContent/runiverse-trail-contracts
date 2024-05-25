# Runiverse Trail Contracts

A home for the contracts that support the Runiverse Trail game

## Getting Started

1 Install dependencies

```bash
npm install
```

2. Setup environment. Copy `.env.sample` to `.env` and swap the values for your keys

```bash
ETHERSCAN_API_KEY="API_KEY_FROM_ETHERSCAN"
ALCHEMY_API_KEY="API_KEY_FROM_ALCHEMY"
GOERLI_PRIVATE_KEY="(Optional) GOERLI_PK"
ETHEREUM_PRIVATE_KEY="ETHEREUM_PK"
REPORT_GAS=true
```

3. Run tests

```bash
npx hardhat test
```

## Deploying

1. Deploy using Hardhat -- Swap `{yourNetwork} with the name of the deploy target

```bash
npx hardhat run --network {yourNetwork} scripts/deploy.js
```

2. Verify using Hardhat

```bash
npx hardhat verify --network {yourNetwork} {contractAddress}
```

3. Done!