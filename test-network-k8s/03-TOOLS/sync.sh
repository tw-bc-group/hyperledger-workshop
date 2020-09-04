#!/bin/bash

app=cli
: ${NS:=testnet}

echo "use namespaces $NS"
echo "find cli pod"
POD=$(kubectl -n $NS get pods -l app=$app -o=jsonpath='{.items[0].metadata.name}')
if [[ -z $POD ]]; then
  echo "$app pod not found!..."
else
  echo "find pod $POD"
fi

echo 'Sync first-network to cli, do you want to continue?(y/n)'
read is_continue
if [[ "$is_continue" =~ 'y' ]]; then
  echo 'user confirmed, continue'
else
  echo 'user canceled!'
  exit 1
fi

copy_to_cli() {
  source_path=$1
  target_path=$2
  echo "copy $source_path to $target_path"
  set -x
  kubectl -n $NS -c tools cp \
    $source_path \
    $NS/$POD:$target_path \
    && kubectl -n $NS -c tools exec $POD -- \
      ls -l $target_path
  set +x
}


copy_to_cli ../../first-network /var/hyperledger
copy_to_cli ./tools /var/hyperledger
