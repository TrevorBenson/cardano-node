#!/bin/bash

. ~/.bashrc

if [ -n "$1" ]; then
  NETWORK=$1
fi

echo "NETWORK: $NETWORK";

[[ -z "${CNODE_HOME}" ]] && export CNODE_HOME=/opt/cardano/cnode 
[[ -z "${CNODE_PORT}" ]] && export CNODE_PORT=6000
#export POOL=$@ 

echo "NODE: $HOSTNAME";
cardano-node --version;

#sudo touch /etc/crontab /etc/cron.*/*
#sudo cron  > /dev/null 2>&1
#sudo /etc/init.d/promtail start > /dev/null 2>&1

#if [[ $NETWORK = "master" ]] ; then
#  sudo bash /home/guild/.scripts/master-topology.sh > /dev/null 2>&1
#fi

if [[ $NETWORK = "testnet" ]] ; then
  ln -sf $CNODE_HOME/files/testnet-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/testnet-shelley-genesis.json $CNODE_HOME/files/genesis.json
  ln -sf $CNODE_HOME/files/testnet-config.json $CNODE_HOME/files/config.json
else
  ln -sf $CNODE_HOME/files/mainnet-byron-genesis.json $CNODE_HOME/files/byron-genesis.json
  ln -sf $CNODE_HOME/files/mainnet-shelley-genesis.json $CNODE_HOME/files/genesis.json
  ln -sf $CNODE_HOME/files/mainnet-config.json $CNODE_HOME/files/config.json
fi


#if [[ $NETWORK = "guild_relay" ]] ; then
#  sudo bash /home/guild/.scripts/guild-topology.sh > /dev/null 2>&1
#fi


#if [[ ! -d "/tmp/mainnet-combo-db" ]] && [[ $NETWORK != "master" ]]  ; then
#  cp -rf $CNODE_HOME/priv/mainnet-combo-db /tmp/mainnet-combo-db
#else 
#  rm -rf /tmp/mainnet-combo-db
#  cp -rf $CNODE_HOME/priv/mainnet-combo-db /tmp/mainnet-combo-db
#fi

# Create the Node operation keys
#cardano-cli shelley node key-gen-VRF --verification-key-file $CNODE_HOME/priv/vrf.vkey --signing-key-file $CNODE_HOME/priv/vrf.skey
#cardano-cli shelley node key-gen-KES --verification-key-file $CNODE_HOME/priv/kes.vkey --signing-key-file $CNODE_HOME/priv/kes.skey
# TODO: Process to propogate keys in genesis to members
#cardano-cli shelley node issue-op-cert --hot-kes-verification-key-file $CNODE_HOME/priv/kes.vkey --cold-signing-key-file $CNODE_HOME/priv/delegate.skey --operational-certificate-issue-counter $CNODE_HOME/priv/delegate.counter --kes-period 0 --out-file $CNODE_HOME/priv/ops.cert 

# EKG Exposed
#socat -d tcp-listen:12782,reuseaddr,fork tcp:127.0.0.1:12781 

#exec cardano-node run \
#  --config $CNODE_HOME/files/config.json \
#  --database-path $CNODE_HOME/db \
#  --host-addr 0.0.0.0 \
#  --port $CNODE_PORT \
#  --socket-path $CNODE_HOME/sockets/node0.socket \
#  --topology $CNODE_HOME/priv/files/topology.json

$CNODE_HOME/scripts/cnode.sh

else
  echo "Please set a NETWORK environment variable to one of: testnet/master"
  echo "To modify topology.json map a container volume of this file to $CNODE_HOME/files/topology.json for a read/write -v /my/files/topology.json:$CNODE_HOME/files/topology.json:rw otherwise set rw to ro if you want it read only inside the container."
  echo "To enable a POOL pass in POOL_DIR environment variable"
fi
