docker exec -ti fabric-cli bash
export CHANNEL_NAME='retail-channel'

export CORE_PEER_ADDRESS=orderer.farmer.com:7050
export CORE_PEER_LOCALMSPID=OrdererFarmer
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/users/Admin@farmer.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'

peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json

jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"OrdererTransport":.[1]}}}}}' config.json ./channel-artifacts/orderer-transport.json > modified_config_orderer.json

transport_tls_cert=$(base64 ./crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/tls/server.crt)
consenter_transport='[{         
    "client_tls_cert": "'${transport_tls_cert}'",
    "host": "orderer.transport.com",
    "port": 7050,
    "server_tls_cert": "'${transport_tls_cert}'"
}]'
jq ".channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += ${consenter_transport}" modified_config_orderer.json > modified_config_consenter.json

host_transport_orderer='["orderer.transport.com:7050"]'
jq ".channel_group.values.OrdererAddresses.value.addresses += ${host_transport_orderer}" modified_config_consenter.json > modified_config_transport.json

configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output org_transport_update.pb
configtxlator proto_decode --input org_transport_update.pb --type common.ConfigUpdate | jq . > org_transport_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"retail-channel", "type":2}},"data":{"config_update":'$(cat org_transport_update.json)'}}}' | jq . > org_transport_update_in_envelope.json
configtxlator proto_encode --input org_transport_update_in_envelope.json --type common.Envelope --output org_transport_update_in_envelope.pb
peer channel signconfigtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 


export CORE_PEER_ADDRESS=orderer.supermarket.com:7050
export CORE_PEER_LOCALMSPID=OrdererSupermarket
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/users/Admin@supermarket.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
#peer channel signconfigtx -o orderer.supermarket.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
peer channel update -o orderer.supermarket.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 

peer channel fetch newest retail-channel-latest.block -o orderer.supermarket.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input retail-channel-latest.block --type common.Block

export CORE_PEER_ADDRESS=apple.farmer.com:7051
export CORE_PEER_LOCALMSPID=FarmerMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'

peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
#configtxlator proto_decode --input config_block.pb --type common.Block
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"TransportMSP":.[1]}}}}}' config.json ./channel-artifacts/msp-transport.json > modified_config_transport.json

configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output org_transport_update.pb
configtxlator proto_decode --input org_transport_update.pb --type common.ConfigUpdate | jq . > org_transport_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"retail-channel", "type":2}},"data":{"config_update":'$(cat org_transport_update.json)'}}}' | jq . > org_transport_update_in_envelope.json
configtxlator proto_encode --input org_transport_update_in_envelope.json --type common.Envelope --output org_transport_update_in_envelope.pb
peer channel signconfigtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
#peer channel update -o orderer.farmer.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 


export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
export CORE_PEER_LOCALMSPID=SupermarketMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
peer channel update -o orderer.supermarket.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 

peer channel fetch newest retail-channel-latest.block -o orderer.supermarket.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input retail-channel-latest.block --type common.Block

export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
export CORE_PEER_LOCALMSPID=TransportMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'

peer channel fetch 0 retail-channel-0.block -o orderer.transport.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
peer channel join -b ./retail-channel-0.block 
peer channel getinfo -c ${CHANNEL_NAME}

export CORE_PEER_ADDRESS=refrigerated.truck.transport.com:15051

peer channel join -b ./retail-channel-0.block 
peer channel getinfo -c ${CHANNEL_NAME}