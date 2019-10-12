# Add New Org (Orderer and MSP) in Running Fabric Network #

## Add Transport Orerder ##

### Create Transport Orderer and MSP Update Config ###

~~~shell
cd org-transport
rm -rf crypto-config
../bin/cryptogen generate --config=./transport-crypto.yaml
cp -r ./crypto-config/* ../crypto-config/
export FABRIC_CFG_PATH=$pwd && ../bin/configtxgen --printOrg TransportMSP > ../channel-artifacts/msp-transport.json
export FABRIC_CFG_PATH=$pwd && ../bin/configtxgen --printOrg OrdererTransport > ../channel-artifacts/orderer-transport.json
~~~

### Prerequisite ###
* Generate Food Network
~~~
rm -rf crypto-config
bin/cryptogen generate --config=./crypto-config.yaml
mkdir -p channel-artifacts
rm -rf channel-artifacts/*
bin/configtxgen -profile FoodWithEtcdRaft -channelID food-sys-channel -outputBlock ./channel-artifacts/genesis.block
bin/configtxgen -profile RetailChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID retail-channel
bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/FarmerMSPanchors.tx -channelID retail-channel -asOrg FarmerMSP
bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/SupermarketMSPanchors.tx -channelID retail-channel -asOrg SupermarketMSP
~~~

* Bring up Food Network
~~~
docker-compose -f docker-compose-farmer.yaml -f docker-compose-supermarket.yaml -f docker-compose-cli.yaml up -d
~~~

* Create Channel "retail-channel"
* Install Chaincode "fabcar" on retail-channel


### Update Orderer and System Channel Config ###

#### Create Update via order.farmer.com ####

Login Fabric CLI

~~~
docker exec -ti fabric-cli bash
~~~

Operate on System Channel

~~~
export SYS_CHANNEL_NAME='food-sys-channel'
~~~

Set up Peer Environment (orderer.farmer.com)

To update config of System Channel, CLI must connect to an Orderer node.

~~~
export CORE_PEER_ADDRESS=orderer.farmer.com:7050
export CORE_PEER_LOCALMSPID=OrdererFarmer
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/users/Admin@farmer.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'
~~~

Fetch System Channel Config and export it as json

~~~
peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $SYS_CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
~~~

Add Transport MSP to System Channel Config
~~~
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"OrdererTransport":.[1]}}}}}' config.json ./channel-artifacts/orderer-transport.json > modified_config_application.json
~~~

Add Transport Orerder to System Channel Config
~~~
jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"OrdererTransport":.[1]}}}}}' modified_config_application.json ./channel-artifacts/orderer-transport.json > modified_config_orderer.json
~~~

Add Transport to Consortium
~~~
jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"FoodConsortium": {"groups":{"TransportMSP":.[1]}}}}}}} * {"channel_group":{"groups":{"Consortiums":{"groups": {"RetailConsortium": {"groups":{"TransportMSP":.[2]}}}}}}}' modified_config_orderer.json  ./channel-artifacts/msp-transport.json  ./channel-artifacts/msp-transport.json > modified_config_consortium.json
~~~

Add Transport Orderer to Consenter
~~~
transport_tls_cert=$(base64 ./crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/tls/server.crt)
consenter_transport='[{         
    "client_tls_cert": "'${transport_tls_cert}'",
    "host": "orderer.transport.com",
    "port": 7050,
    "server_tls_cert": "'${transport_tls_cert}'"
}]'
jq ".channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += ${consenter_transport}" modified_config_consortium.json > modified_config_consenter.json
~~~

Add Transport Orderer Address to Oreders Address

~~~
host_transport_orderer='["orderer.transport.com:7050"]'
jq ".channel_group.values.OrdererAddresses.value.addresses += ${host_transport_orderer}" modified_config_consenter.json > modified_config_transport.json
~~~

#### Update the config to System Channel ####

Encode the original config
~~~
configtxlator proto_encode --input config.json --type common.Config --output config.pb
~~~

Encode the updated config
~~~
configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
~~~

Calculate the config difference
~~~
configtxlator compute_update --channel_id $SYS_CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output orderer_transport_update.pb
~~~

Decode the difference to JSON
~~~
configtxlator proto_decode --input orderer_transport_update.pb --type common.ConfigUpdate | jq . > orderer_transport_update.json
~~~

Wrap the difference in Envelope
~~~
echo '{"payload":{"header":{"channel_header":{"channel_id":"food-sys-channel", "type":2}},"data":{"config_update":'$(cat orderer_transport_update.json)'}}}' | jq . > orderer_transport_update_in_envelope.json
~~~

Encode the updated Envelope
~~~
configtxlator proto_encode --input orderer_transport_update_in_envelope.json --type common.Envelope --output orderer_transport_update_in_envelope.pb
~~~

Sign the update
~~~
peer channel signconfigtx -o orderer.farmer.com:7050 -f orderer_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
~~~

#### Update Channel on Supermarket ####

Update Channel on Supermarket
~~~shell
export CORE_PEER_ADDRESS=orderer.supermarket.com:7050
export CORE_PEER_LOCALMSPID=OrdererSupermarket
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/users/Admin@supermarket.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
peer channel update -o orderer.supermarket.com:7050 -c $SYS_CHANNEL_NAME  -f orderer_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
~~~

#### Update Bootstrap Block for Transport Orderer ####

Get Latest Config Block
~~~
peer channel fetch config system-channel-latest.block -o orderer.supermarket.com:7050 -c $SYS_CHANNEL_NAME --tls --cafile $ORDERER_CA
cp system-channel-latest.block ./channel-artifacts/
~~~

Set Latest Config Block as Genesis Block for Transport Orderer in docker-compose-transport.yaml

~~~
  orderer.transport.com:
    container_name: orderer.transport.com
    extends:
      file: peer-base.yaml
      service: orderer-base
    environment:
      - ORDERER_GENERAL_LOCALMSPID=OrdererTransport
      - FABRIC_LOGGING_SPEC=DEBUG
    volumes:
        - ./channel-artifacts/system-channel-latest.block:/var/hyperledger/orderer/orderer.genesis.block
        - ./crypto-config/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp:/var/hyperledger/orderer/msp
        - ./crypto-config/ordererOrganizations/transport.com/orderers/orderer.transport.com/tls/:/var/hyperledger/orderer/tls
        - orderer.transport.com:/var/hyperledger/production/orderer
    #ports:
    #  - 7050:7050
    networks:
      - foodnetwork
~~~

#### Verify Channel Config ####

~~~
peer channel fetch newest system-channel-latest.block -o orderer.supermarket.com:7050 -c $SYS_CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input system-channel-latest.block --type common.Block
~~~

### Bring up Treansport Nodes ####

~~~
docker-compose -f docker-compose-transport.yaml up -d
docker logs orderer.transport.com  -f
~~~

### Add Transport Orerder to retail-channel ###
The procedure is similar as adding it to System Channel

Set channel to retail-channel

~~~
export CHANNEL_NAME='retail-channel'
~~~


~~~
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

~~~
### Add Transport to retail-channel ###

Set channel to retail-channel

~~~
export CHANNEL_NAME='retail-channel'
~~~

Connect to Peer Node apple.farmer.com, update config, calculate difference, encode config and sign the update

~~~
export CORE_PEER_ADDRESS=apple.farmer.com:7051
export CORE_PEER_LOCALMSPID=FarmerMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'

peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"TransportMSP":.[1]}}}}}' config.json ./channel-artifacts/msp-transport.json > modified_config.json

configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output org_transport_update.pb
configtxlator proto_decode --input org_transport_update.pb --type common.ConfigUpdate | jq . > org_transport_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"retail-channel", "type":2}},"data":{"config_update":'$(cat org_transport_update.json)'}}}' | jq . > org_transport_update_in_envelope.json
configtxlator proto_encode --input org_transport_update_in_envelope.json --type common.Envelope --output org_transport_update_in_envelope.pb
peer channel signconfigtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
~~~

Update channel config on Supermarket Peer Node

~~~
export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
export CORE_PEER_LOCALMSPID=SupermarketMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
peer channel update -o orderer.supermarket.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
~~~

Get First block in retail-channel

~~~
peer channel fetch 0 retail-channel-0.block -o orderer.supermarket.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
~~~

#### Transport Join Channel ####

Switch to peers of Transport in CLI, and join retail-channel per Peer

~~~
export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
export CORE_PEER_LOCALMSPID=TransportMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp
export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'

export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
peer channel join -b ./retail-channel-0.block 

export CORE_PEER_ADDRESS=refrigerated.truck.transport.com:15051
peer channel join -b ./retail-channel-0.block 
~~~

Verify 
~~~
peer channel getinfo -c ${CHANNEL_NAME}
~~~


### Install and Run Chaincode ###

~~~
export CHAINCODE_VERSION=1
export CHAINCODE_NAME=fabcar
export CHAINCODE_SEQUENCE=1
export CHANNEL_NAME=retail-channel


export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
export CORE_PEER_LOCALMSPID=TransportMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'
export PACKAGE_ID="${CHAINCODE_NAME}_${CHAINCODE_VERSION}:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c"
peer lifecycle chaincode approveformyorg --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --waitForEvent --package-id ${PACKAGE_ID} --orderer orderer.transport.com:7050
peer chaincode query -o orderer.transport.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME}  -c '{"Args":["queryAllCars"]}' 
~~~


## Tips ##

* Must set Bootstrap Block for newly added Orderer Node

## References ##

[How to add a new orderer in a running hyperledger fabric network using raft?](https://stackoverflow.com/questions/57571629/how-to-add-a-new-orderer-in-a-running-hyperledger-fabric-network-using-raft)

[New RAFT orderer cannot detect that it belongs to an application channel](https://stackoverflow.com/questions/56057187/new-raft-orderer-cannot-detect-that-it-belongs-to-an-application-channel)

[Adding an Org to a Channel](https://hyperledger-fabric.readthedocs.io/en/latest/channel_update_tutorial.html)

[Some questions about the orderer service](https://lists.hyperledger.org/g/fabric/topic/some_questions_about_the/19215615?p=,,,20,0,0,0::recentpostdate%2Fsticky,,,20,2,0,19215615)

[How to Add an Organization dynamically to existing consortium — Hyperledger Fabric](https://medium.com/@rsripathi781/how-to-add-an-organization-dynamically-to-existing-consortium-hyperledger-fabric-36b4c923b937)

[Add a New Organization on Existing Hyperledger Fabric Network](https://medium.com/@kctheservant/add-a-new-organization-on-existing-hyperledger-fabric-network-2c9e303955b2)


