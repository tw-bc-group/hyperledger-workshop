export FIRST_NETWORK=/var/hyperledger/first-network
export FABRIC_CFG_PATH=$FIRST_NETWORK
export PEER_ORG1_PATH=/var/hyperledger/first-network/crypto-config/peerOrganizations/org1.testnet.svc.cluster.local
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER_ORG1_PATH}/peers/peer0.org1.testnet.svc.cluster.local
export CORE_PEER_MSPCONFIGPATH=${PEER_ORG1_PATH}/msp
export CORE_PEER_ADDRESS=peer0.org1.testnet.svc.cluster.local:7051
