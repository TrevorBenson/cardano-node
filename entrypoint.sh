#!/bin/bash

. ~/.bashrc

if [ -n "$1" ]; then
  NETWORK=$1
fi

echo "NETWORK: $NETWORK";

[[ -z "${CNODE_HOME}" ]] && export CNODE_HOME=/opt/cardano/cnode 
[[ -z "${CNODE_PORT}" ]] && export CNODE_PORT=6000

echo "NODE: $HOSTNAME";
cardano-node --version;

if [[ $NETWORK = "testnet" ]] ; then
  ln -sf $CNODE_HOME/files/testnet-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/testnet-shelley-genesis.json $CNODE_HOME/files/genesis.json
  jq '.hasEKG = ["0.0.0.0", 12788] | .hasPrometheus = ["0.0.0.0", 12798]' $CNODE_HOME/files/config-testnet.json > $CNODE_HOME/files/config.json
elif [[ $NETWORK = "mainnet" ]] ; then
  ln -sf $CNODE_HOME/files/mainnet-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/mainnet-shelley-genesis.json $CNODE_HOME/files/genesis.json
  jq '.hasEKG = ["0.0.0.0", 12788] | .hasPrometheus = ["0.0.0.0", 12798]' $CNODE_HOME/files/config-mainnet.json > $CNODE_HOME/files/config.json
elif [[ $NETWORK = "allegra" ]] ; then
  ln -sf $CNODE_HOME/files/allegra-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/allegra-shelley-genesis.json $CNODE_HOME/files/genesis.json
  jq '.hasEKG = ["0.0.0.0", 12788] | .hasPrometheus = ["0.0.0.0", 12798]' $CNODE_HOME/files/config-allegra.json > $CNODE_HOME/files/config.json
elif [[ $NETWORK = "launchpad" ]] ; then
  ln -sf $CNODE_HOME/files/launchpad-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/launchpad-shelley-genesis.json $CNODE_HOME/files/genesis.json
  jq '.hasEKG = ["0.0.0.0", 12788] | .hasPrometheus = ["0.0.0.0", 12798]' $CNODE_HOME/files/config-launchpad.json > $CNODE_HOME/files/config.json
fi

if ! [[ -z $NETWORK ]] ; then 
  $CNODE_HOME/scripts/cnode.sh
else
  echo "Please set a NETWORK environment variable to one of: mainnet/testnet/allegra|launchpad"
  echo "To modify topology.json map a container volume of this file to $CNODE_HOME/files/topology.json for a read/write -v /my/files/topology.json:$CNODE_HOME/files/topology.json:rw otherwise set rw to ro if you want it read only inside the container."
  echo "To enable a POOL pass in POOL_NAME environment variable"
fi
