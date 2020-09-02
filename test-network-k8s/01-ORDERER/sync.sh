#!/bin/bash

: ${NS:=testnet}

K="kubectl -n $NS"
source_path=
app=orderer
domain=$NS.svc.cluster.local
source_path=../crypto-config/ordererOrganizations/$domain/orderers/$app.$domain
target_path=/var/hyperledger/orderer

set -x
local POD=$($K get pods -l app=orderer -o=jsonpath='{.items[0].metadata.name}')
set +x

echo "Sync crypto config to $POD"

set -x
$K cp $source_path/msp $NS/$POD:$target_path/msp
$k exec $POD -- ls -l $target_path/msp

$K cp $source_path/tls $NS/$POD:$target_path/tls
$k exec $POD -- ls -l $target_path/tls
set +x

