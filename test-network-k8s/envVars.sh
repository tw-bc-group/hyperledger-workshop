#!/bin/bash

: ${NS:=testnet}

pushd $(dirname $0)
source .env
popd

export NS=$NS
alias k='kubectl -n $NS '
alias h='helm -n $NS '

