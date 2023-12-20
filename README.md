# Aztec Starter

This repo is meant to be a starting point for writing Aztec contracts and tests.

You can find the Easy Private Voting contract in `./src/main.nr`. A simple integration test is in `./src/test/index.test.ts`, you can run it (after installing packages) with:

```bash
yarn install && yarn test
```

The corresponding tutorial can be found in the [Aztec docs here](https://docs.aztec.network/dev_docs/tutorials/writing_private_voting_contract).

## Getting Started

[Start your codespace from the codespace dropdown](https://docs.github.com/en/codespaces/getting-started/quickstart).

Get and run the sandbox with this command:

```bash
/bin/bash -c "$(curl -fsSL 'https://sandbox.aztec.network')"
```

## Install packages

```bash
yarn install
```

## Compile

```bash
aztec-cli compile . --typescript ./src/artifacts
```

or

```bash
yarn compile
```

## Deploy

Add `ADMIN` to your environment.

```bash
ADMIN=0x1d30d4de97657983408587c7a91ba6587774b30f0e70224a0658f0357092f495
```

```bash
aztec-cli deploy ./target/EasyPrivateVoting.json --args $ADMIN
```

## Test

```bash
yarn test
```

## Error resolution

### Update Contract

Get the contract code from the monorepo. The script will look at the versions defined in `./Nargo.toml` and fetch that version of the code from the monorepo.

```bash
yarn update
```

You may need to update permissions with:

```bash
chmod +x update_contract.sh
```