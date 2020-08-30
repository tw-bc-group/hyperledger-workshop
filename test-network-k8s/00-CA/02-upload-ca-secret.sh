#!/bin/bash



if [[ -z $1 ]] ; then
  cat <<EOF
Usage:
  NS=<namespace> $0 <org>
EOF
  exit
fi

: ${NS:=testnet}
org=$1

echo "upload $org's certs"
set -x
kubectl -n $NS create secret generic ca-$org-cert --from-file=./ca/$org/intermediate/certs
set +x

echo "upload $org's private key"
set -x
kubectl -n $NS create secret generic ca-$org-key --from-file=./ca/$org/intermediate/private
set +x
