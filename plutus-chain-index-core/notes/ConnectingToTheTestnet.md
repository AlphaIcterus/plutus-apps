# How to connect to a testnet

## Get `cardano-node` onto the path

The easiest way of doing this is to enter this repository's `nix develop`, where one is already there by default. Other alternatives include downloading pre-built binaries, running Docker, running a Nix shell or building from source. See [the node's repository](https://github.com/input-output-hk/cardano-node) for more information.

## Download the node configurations

You can download the node configurations from [here](https://hydra.iohk.io/build/7366583/download/1/index.html).
You need to download the configurations for the node, genesis blocks and the topology.

## Start the node

I am using a shell script to start the node that I will paste here:

```shell
#!/usr/bin/env bash

cardano-node -- run \
    --config ./alonzo-purple-config.json \
    --topology ./alonzo-purple-topology.json \
    --database-path testnet/db \
    --socket-path /tmp/node-server.sock \
    --port 3003
```

## Troubleshooting

### 1. Synchronisation stops after a number of blocks.

I was getting this error message:

```
[𝝺:cardano.node.DnsSubscription:Error:111] [2021-09-23 09:25:36.12 UTC] Domain: "relays.alonzo-purple.dev.cardano.org" Application Exception: 3.64.236.32:3001 HeaderError (At (Block {blockPointSlot = SlotNo 2261160, blockPointHash = f9dee539ef2f498021a0ff5bb522849da957a33e81be5f01d9bd687140d81b37})) (HeaderEnvelopeError (OtherHeaderEnvelopeError (HardForkEnvelopeErrFromEra S (S (S (S (Z (WrapEnvelopeErr {unwrapEnvelopeErr = ObsoleteNodeCHAIN 6 5})))))))) (Tip (SlotNo 2259021) db47db2f7d0f667f4203fbd242da8cb089994cccebe77134563304330eb692cf (BlockNo 104553)) (Tip (SlotNo 2907080) 5fe3cdde5510898c0d324557b7040f1f486ce84058778a181c28249daab44405 (BlockNo 131683))
```

This was due to using an old version of the node, which does not support the required protocol version. The solution was to get the latest master from the `[cardano-node](https://github.com/input-output-hk/cardano-node)` repository, go into `nix-shell` and run cardano-node from there.
