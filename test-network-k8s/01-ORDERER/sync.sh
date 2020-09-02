#!/bin/bash

: ${NS:=testnet}

K="kubectl -n $NS"
app=orderer
domain="$NS.svc.cluster.local"
source_path=../../first-network/crypto-config/ordererOrganizations/$domain/orderers/$app.$domain
target_path=/var/hyperledger/orderer

set -x
POD=$($K get pods -l app=orderer -o=jsonpath='{.items[0].metadata.name}')
set +x

echo "Sync crypto config to $POD"

set -x
$K cp $source_path/msp $NS/$POD:$target_path/
$K exec $POD -- ls -l $target_path/msp

$K cp $source_path/tls $NS/$POD:$target_path/
$K exec $POD -- ls -l $target_path/tls
set +x

