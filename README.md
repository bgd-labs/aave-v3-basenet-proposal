## Summary

This proposal allows the Aave governance to activate the Aave V3 Base pool (3.0.2) by completing all the initial setup and listing WETH, USDbC and cbETH as suggested by the risk service providers (Gauntlet and Chaos Labs) on the [governance forum](https://governance.aave.com/t/arfc-aave-v3-deployment-on-base/13708/10). All the Aave Base V3 addresses can be found in the [aave-address-book](https://github.com/bgd-labs/aave-address-book/blob/main/src/AaveV3Base.sol).

This deployment aims to expand Aave to a new ecosystem, capturing the growth and infrastructure allowed by Coinbase’s products and distribution -- providing new opportunities for both ecosystems.

## Motivation

By enabling Base on Aave, it creates valuable (and differentiated) revenue opportunities for Aave, capturing the growth and interest of users who live on the Coinbase platform.

This allows Aave to leverage Coinbase integrations, fiat onramps, and access to 110mm+ users and $80B+ assets in the Coinbase ecosystem.

For Base, deploying Aave V3's codebase expands the on-chain experience by fostering a diversity of DeFi platforms and introducing trusted, flagship lending protocols.

## Specification

The ARFC suggests deploying Aave V3 on Base with the following assets for collateral: wETH, cbETH, and USDC.

The table below illustrates the initial suggested risk parameters for each asset, a combination of reccomendations provided by @Gauntlet and @ChaosLabs.

|                          | WETH           | USDC      | cbETH          |
| ------------------------ | -------------- | --------- | -------------- |
| Isolation Mode           | NO             | NO        | NO             |
| Enable Borrow            | YES            | YES       | YES            |
| Enable Collateral        | YES            | YES       | YES            |
| Emode Category           | eth-correlated | N/A       | eth-correlated |
| Loan To Value            | 80%            | 77%       | 67%            |
| Liquidation Threshold    | 83%            | 80%       | 74%            |
| Liquidation Bonus        | 5%             | 5%        | 7.5%           |
| Reserve Factor           | 15%            | 10%       | 15%            |
| Liquidation Protocol Fee | 10%            | 10%       | 10%            |
| Supply Cap               | 200            | 1,000,000 | 100            |
| Borrow Cap               | 160            | 800,000   | 20             |
| Debt Ceiling             | N/A            | N/A       | N/A            |
| uOptimal                 | 80%            | 90%       | 45%            |
| Base                     | 0%             | 0%        | 0%             |
| Slope1                   | 3.8%           | 4%        | 7%             |
| Slope2                   | 80%            | 60%       | 300%           |
| Stable Borrowing         | Disabled       | Disabled  | Disabled       |
| Flahloanable             | YES            | YES       | YES            |
| Siloed Borrowing         | NO             | NO        | NO             |
| Borrowed in Isolation    | NO             | YES       | NO             |

**E-Mode:**

| Category       | Assets included | LT  | LTV | Liquidation Bonus |
| -------------- | --------------- | --- | --- | ----------------- |
| eth-correlated | WETH, cbETH     | 93% | 90% | 2%                |

cbEth adapter: [0x80f2c02224a2E548FC67c0bF705eBFA825dd5439](https://basescan.org/address/0x80f2c02224a2e548fc67c0bf705ebfa825dd5439)

wstEth adapter: [0x945fD405773973d286De54E44649cc0d9e264F78](https://basescan.org/address/0x945fd405773973d286de54e44649cc0d9e264f78)

## Development

This project uses [Foundry](https://getfoundry.sh). See the [book](https://book.getfoundry.sh/getting-started/installation.html) for detailed instructions on how to install and use Foundry.
The template ships with sensible default so you can use default `foundry` commands without resorting to `MakeFile`.

### Setup

```sh
cp .env.example .env
forge install
```

### Test

```sh
forge test
```

## Advanced features

### Diffing

For contracts upgrading implementations it's quite important to diff the implementation code to spot potential issues and ensure only the intended changes are included.
Therefore the `Makefile` includes some commands to streamline the diffing process.

#### Download

You can `download` the current contract code of a deployed contract via `make download chain=polygon address=0x00`. This will download the contract source for specified address to `src/etherscan/chain_address`. This command works for all chains with a etherscan compatible block explorer.

#### Git diff

You can `git-diff` a downloaded contract against your src via `make git-diff before=./etherscan/chain_address after=./src out=filename`. This command will diff the two folders via git patience algorithm and write the output to `diffs/filename.md`.

**Caveat**: If the onchain implementation was verified using flatten, for generating the diff you need to flatten the new contract via `forge flatten` and supply the flattened file instead fo the whole `./src` folder.
