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
app=${org}-${peer}
source_path=../crypto-config/peerOrganizations/$org.example.com/peers/$peer.$org.example.com
echo $source_path


set -x
POD=$(kubectl -n $NS get pods -l app=$app -o=jsonpath='{.items[0].metadata.name}')

kubectl -n $NS cp $source_path/msp $NS/$POD:/etc/hyperledger/fabric
kubectl -n $NS cp $source_path/tls $NS/$POD:/etc/hyperledger/fabric
set +x
