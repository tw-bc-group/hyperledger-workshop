#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

: ${USE_DOMAIN:=0}

# set tools and config
# working path is first-network
export PROJECT_ROOT=${PWD}/..
export PATH=$PROJECT_ROOT/bin:$PATH
export FABRIC_CFG_PATH=$PROJECT_ROOT/config/

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/testnet.svc.cluster.local/orderers/orderer.testnet.svc.cluster.local/msp/tlscacerts/tlsca.testnet.svc.cluster.local-cert.pem
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.testnet.svc.cluster.local/peers/peer0.org1.testnet.svc.cluster.local/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/org2.testnet.svc.cluster.local/peers/peer0.org2.testnet.svc.cluster.local/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/crypto-config/peerOrganizations/org3.testnet.svc.cluster.local/peers/peer0.org3.testnet.svc.cluster.local/tls/ca.crt

if [ $USE_DOMAIN -eq 1 ] ; then
  : ${ORDERER_ADDRESS:=orderer.testnet.svc.cluster.local:7050}
  : ${PEER0_ORG1_ADDRESS:=peer0.org1.testnet.svc.cluster.local:7051}
  : ${PEER0_ORG2_ADDRESS:=peer0.org2.testnet.svc.cluster.local:9051}
  : ${PEER0_ORG3_ADDRESS:=peer0.org3.testnet.svc.cluster.local:11051}
else
  : ${ORDERER_ADDRESS:=localhost:7050}
  : ${PEER0_ORG1_ADDRESS:=localhost:7051}
  : ${PEER0_ORG2_ADDRESS:=localhost:9051}
  : ${PEER0_ORG3_ADDRESS:=localhost:11051}
fi
export ORDERER_ADDRESS
export PEER0_ORG1_ADDRESS
export PEER0_ORG2_ADDRESS
export PEER0_ORG3_ADDRESS

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/ordererOrganizations/testnet.svc.cluster.local/orderers/orderer.testnet.svc.cluster.local/msp/tlscacerts/tlsca.testnet.svc.cluster.local-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/ordererOrganizations/testnet.svc.cluster.local/users/Admin@testnet.svc.cluster.local/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.testnet.svc.cluster.local/users/Admin@org1.testnet.svc.cluster.local/msp
    export CORE_PEER_ADDRESS=${PEER0_ORG1_ADDRESS}
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.testnet.svc.cluster.local/users/Admin@org2.testnet.svc.cluster.local/msp
    export CORE_PEER_ADDRESS=${PEER0_ORG2_ADDRESS}

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org3.testnet.svc.cluster.local/users/Admin@org3.testnet.svc.cluster.local/msp
    export CORE_PEER_ADDRESS=${PEER0_ORG3_ADDRESS}
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer adresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
