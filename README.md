# testnet-test-token-contract

`TestnetTestToken` is a basic [OpenZeppelin](https://docs.openzeppelin.com/contracts/5.x/erc20) ERC20 for testnets. It's built with [Foundry](https://getfoundry.sh) and deploys to Robinhood Chain Testnet.

| | |
|---|---|
| Name | `TestnetTestToken` |
| Symbol | `TTT` |
| Decimals | 18 |
| Supply | 1,000,000 TTT, all minted to the deployer |

The contract is in [`src/TestnetTestToken.sol`](src/TestnetTestToken.sol). It has no owner, so nobody can mint more tokens after deployment.

## Robinhood Chain Testnet

| | |
|---|---|
| Chain ID | `46630` |
| Gas token | ETH |
| Public RPC | `https://rpc.testnet.chain.robinhood.com` (rate-limited; aliased as `robinhood_testnet` in `foundry.toml`) |
| Explorer | https://explorer.testnet.chain.robinhood.com |
| Faucet | https://faucet.testnet.chain.robinhood.com |
| Docs | https://docs.robinhood.com/chain |

## Setup

Install Foundry:

```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Clone the repo with its submodules (`forge-std` and `openzeppelin-contracts`):

```sh
git clone --recurse-submodules https://github.com/jarrensj/testnet-test-token-contract.git
cd testnet-test-token-contract
# already cloned without submodules? run: git submodule update --init --recursive
```

Build and test:

```sh
forge build
forge test
```

## Deploy to Robinhood Chain Testnet

**1. Create a deployer wallet.** Use a throwaway wallet that only ever holds testnet funds. To create a new one:

```sh
cast wallet new
```

**2. Import the key into Foundry's encrypted keystore.** This keeps the private key out of your shell history and out of `.env` files. It prompts for the private key and a password:

```sh
cast wallet import testnet-deployer --interactive
```

**3. Fund the wallet.** Print its address, paste it into the [faucet](https://faucet.testnet.chain.robinhood.com), and confirm the ETH arrived:

```sh
cast wallet address --account testnet-deployer
cast balance $(cast wallet address --account testnet-deployer) --rpc-url robinhood_testnet --ether
```

**4. Deploy and verify.** This deploys the contract and verifies its source on the Blockscout explorer:

```sh
forge create src/TestnetTestToken.sol:TestnetTestToken \
  --rpc-url robinhood_testnet \
  --account testnet-deployer \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url https://explorer.testnet.chain.robinhood.com/api/
```

Note the `Deployed to:` address in the output. The contract page is at `https://explorer.testnet.chain.robinhood.com/address/<contract_address>`.

If verification fails because the explorer hasn't indexed the contract yet, wait a minute and run the verification again:

```sh
forge verify-contract <contract_address> src/TestnetTestToken.sol:TestnetTestToken \
  --rpc-url robinhood_testnet \
  --verifier blockscout \
  --verifier-url https://explorer.testnet.chain.robinhood.com/api/
```

**5. Check the result.** The total supply should be in the deployer's wallet:

```sh
cast call <contract_address> "balanceOf(address)(uint256)" \
  $(cast wallet address --account testnet-deployer) --rpc-url robinhood_testnet
```

To see TTT in your wallet app, add Robinhood Chain Testnet as a network ([guide](https://docs.robinhood.com/chain/add-network-to-wallet)) and import the token by its contract address.
