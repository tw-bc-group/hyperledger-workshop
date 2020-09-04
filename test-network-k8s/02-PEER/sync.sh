#!/bin/bash
if [[ -z $1 ]]; then
  cat <<EOF
Usage:
  $0 <org> <peer>
Example:
  $0 org1 peer1
EOF

  exit 1
fi

: ${NS:=testnet}

org=$1
peer=$2
domain=$NS.svc.cluster.local
app=${org}-${peer}
source_path=../../first-network/crypto-config/peerOrganizations/$org.$domain/peers/$peer.$org.$domain
echo $source_path


set -x
POD=$(kubectl -n $NS get pods -l app=$app -o=jsonpath='{.items[0].metadata.name}')

kubectl -n $NS cp $source_path/msp $NS/$POD:/etc/hyperledger/fabric
kubectl -n $NS cp $source_path/tls $NS/$POD:/etc/hyperledger/fabric
set +x
