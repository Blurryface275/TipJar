# TipJar Smart Contract

## What does this contract do?

This is a simple smart contract to demonstrate how a tip jar can be translated into a decentralized tip jar, where everybody could tip here and the owner can withdraw it and everybody can see via blockchain that the owner of the tip jar already withdraw the tip from this jar.

## Features

### Tip

Just like regular tip jar, everybody can donate to this jar

### WithDraw

What is the main purpose of tip jar if nobody can collect the money from it? SO this is one of the main features that allow the owner of this contract to withdraw all funds from here.

### Transfer Ownership

If the owner is not eligible anymore to this contract, they can transfer their ownership to another address. Remember, it's decentralized and anybody could see who is the current owner.

## Tech Stack

- **Solidity** — main language used to write this contract
- **Foundry** — framework for deploy, testing, and scripting
- **Sepolia** — public testnet blockchain used to deploy this contract

## Prerequisites

- [Foundry](https://getfoundry.sh/)
- Sepolia ETH (get from faucet)
- RPC URL (Alchemy/Infura)

## Getting Started

```shell
$ git clone https://github.com/Blurryface275/TipJar.git
```

```shell
$ cd TipJar
```

## Contract Address

### Link : https://sepolia.etherscan.io/address/0xf2c87Fca8d3C23cc4749Fc2e5026D895ac11c02a#events

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```
