
## Question

### Hyperledger fabric Error : mychannel received discovery error:access denied

Did you follow the register and enroll step ?

node enrollAdmin.js && node registerUser.js && node query.js

If yes :

First delete the folder wallet.

In fabcar directory run : ./startFabric.sh javascript

Repeat the register and enroll step: node enrollAdmin.js && node registerUser.js && node query.js


### Peer Invokde

peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n fabcar --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"function":"changeCarOwner","Args":["CAR9","Dave"]}'
