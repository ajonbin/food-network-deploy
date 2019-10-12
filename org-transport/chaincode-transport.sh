export CHAINCODE_VERSION=1
export CHAINCODE_NAME=fabcar
export CHAINCODE_SEQUENCE=1
export CHANNEL_NAME=r'etail-channel'


export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
export CORE_PEER_LOCALMSPID=TransportMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

export PACKAGE_ID="${CHAINCODE_NAME}_${CHAINCODE_VERSION}:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c"
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'
peer lifecycle chaincode approveformyorg --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --waitForEvent --package-id ${PACKAGE_ID} --orderer orderer.transport.com:7050
peer lifecycle chaincode queryapprovalstatus --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --orderer orderer.transport.com:7050
peer chaincode query -o orderer.transport.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME}  -c '{"Args":["queryAllCars"]}' 
