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
output=./ca/$org/ca-$org.yaml

echo "create $org's kubernetes manifes from template"
set -x
cat template/ca-template.yaml | sed "s/{{org}}/$org/" > $output
set +x

echo "setup $org CA server"
set -x
kubectl -n $NS apply -f $output
set +x
