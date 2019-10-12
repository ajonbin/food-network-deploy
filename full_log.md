# Full Log #

## Generate and Bring up Food Network ##

~~~ shell
food-network-deploy ajonbin$ ./generate_food_network.sh 
+ rm -rf crypto-config
+ bin/cryptogen generate --config=./crypto-config.yaml
farmer.com
supermarket.com
+ mkdir -p channel-artifacts
+ rm -rf channel-artifacts/FarmerMSPanchors.tx channel-artifacts/SupermarketMSPanchors.tx channel-artifacts/channel.tx channel-artifacts/genesis.block channel-artifacts/msp-transport.json channel-artifacts/orderer-transport.json channel-artifacts/system-channel-latest.block
+ bin/configtxgen -profile FoodWithEtcdRaft -channelID food-sys-channel -outputBlock ./channel-artifacts/genesis.block
2019-10-12 11:19:04.073 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 002 Orderer.BatchTimeout unset, setting to 2s
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 Orderer.BatchSize.MaxMessageCount unset, setting to 500
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 004 Orderer.BatchSize.AbsoluteMaxBytes unset, setting to 10485760
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 005 Orderer.BatchSize.PreferredMaxBytes unset, setting to 2097152
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 006 orderer type: etcdraft
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 007 Orderer.EtcdRaft.Options unset, setting to tick_interval:"500ms" election_tick:10 heartbeat_tick:1 max_inflight_blocks:5 snapshot_interval_size:20971520 
2019-10-12 11:19:04.113 CST [common.tools.configtxgen.localconfig] Load -> INFO 008 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.145 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 009 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.150 CST [common.tools.configtxgen] doOutputBlock -> INFO 00a Generating genesis block
2019-10-12 11:19:04.151 CST [common.tools.configtxgen] doOutputBlock -> INFO 00b Writing genesis block
+ bin/configtxgen -profile RetailChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID retail-channel
2019-10-12 11:19:04.237 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 11:19:04.257 CST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.277 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.277 CST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 004 Generating new channel configtx
2019-10-12 11:19:04.280 CST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 005 Writing new channel tx
+ bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/FarmerMSPanchors.tx -channelID retail-channel -asOrg FarmerMSP
2019-10-12 11:19:04.312 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 11:19:04.333 CST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.353 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.353 CST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 004 Generating anchor peer update
2019-10-12 11:19:04.354 CST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Writing anchor peer update
+ bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/SupermarketMSPanchors.tx -channelID retail-channel -asOrg SupermarketMSP
2019-10-12 11:19:04.384 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 11:19:04.404 CST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.423 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /Users/ajonbin/farbic_2.0a/food-network-deploy/configtx.yaml
2019-10-12 11:19:04.423 CST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 004 Generating anchor peer update
2019-10-12 11:19:04.425 CST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Writing anchor peer update
food-network-deploy ajonbin$ 
food-network-deploy ajonbin$ ./bringup_food_network.sh 
food-network-deploy ajonbin$ vim bringup_food_network.sh 
food-network-deploy ajonbin$ ./bringup_food_network.sh 
+ docker-compose -f docker-compose-farmer.yaml -f docker-compose-supermarket.yaml -f docker-compose-cli.yaml up -d
Creating volume "food-network_orderer.farmer.com" with default driver
Creating volume "food-network_apple.farmer.com" with default driver
Creating volume "food-network_pear.farmer.com" with default driver
Creating volume "food-network_melon.farmer.com" with default driver
Creating volume "food-network_orderer.supermarket.com" with default driver
Creating volume "food-network_peer0.supermarket.com" with default driver
Creating volume "food-network_peer1.supermarket.com" with default driver
Creating couchdb2                ... done
Creating orderer.farmer.com      ... done
Creating couchdb1                ... done
Creating couchdb0                ... done
Creating orderer.supermarket.com ... done
Creating fabric-cli              ... done
Creating peer1.supermarket.com   ... done
Creating peer0.supermarket.com   ... done
Creating apple.farmer.com        ... done
Creating pear.farmer.com         ... done
Creating melon.farmer.com        ... done
food-network-deploy ajonbin$ 
~~~

## Create retail-channel ##

~~~ shell
food-network-deploy ajonbin$ docker exec -ti fabric-cli bash

bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# export CORE_PEER_LOCALMSPID=FarmerMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# peer channel create -o orderer.farmer.com:7050 -c retail-channel -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem
2019-10-12 05:11:38.118 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:11:38.147 UTC [cli.common] readBlock -> INFO 002 Got status: &{NOT_FOUND}
2019-10-12 05:11:38.159 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
2019-10-12 05:11:38.362 UTC [cli.common] readBlock -> INFO 004 Got status: &{SERVICE_UNAVAILABLE}
2019-10-12 05:11:38.371 UTC [channelCmd] InitCmdFactory -> INFO 005 Endorser and orderer connections initialized
2019-10-12 05:11:38.573 UTC [cli.common] readBlock -> INFO 006 Got status: &{SERVICE_UNAVAILABLE}
2019-10-12 05:11:38.582 UTC [channelCmd] InitCmdFactory -> INFO 007 Endorser and orderer connections initialized
2019-10-12 05:11:38.787 UTC [cli.common] readBlock -> INFO 008 Received block: 0
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block 
2019-10-12 05:12:07.357 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:07.551 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=pear.farmer.com:8051
bash-4.4# peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block
2019-10-12 05:12:13.906 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:14.098 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=melon.farmer.com:9051
bash-4.4# peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block
2019-10-12 05:12:17.656 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:17.859 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# export CORE_PEER_LOCALMSPID=SupermarketMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block
2019-10-12 05:12:24.413 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:24.460 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer1.supermarket.com:13051
bash-4.4# peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block
2019-10-12 05:12:30.362 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:30.407 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# export CORE_PEER_LOCALMSPID=FarmerMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# 
bash-4.4# peer channel update -o orderer.farmer.com:7050 -c retail-channel  -f channel-artifacts/FarmerMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
2019-10-12 05:12:35.976 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:35.990 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# export CORE_PEER_LOCALMSPID=SupermarketMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# 
bash-4.4# peer channel update -o orderer.supermarket.com:7050 -c retail-channel  -f channel-artifacts/SupermarketMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
2019-10-12 05:12:41.532 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:12:41.547 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
bash-4.4# 
bash-4.4# 
~~~

## Install Chaincode on retail-channel ##

~~~ shell
bash-4.4# export CHAINCODE_VERSION=1
bash-4.4# export CHAINCODE_NAME=fabcar
bash-4.4# export CHAINCODE_SEQUENCE=1
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# export CORE_PEER_LOCALMSPID=FarmerMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# 
bash-4.4# peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path github.com/hyperledger/fabric/chaincode/${CHAINCODE_NAME}/go --lang golang --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION}
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:13:25.387 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:13:25.387 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# peer lifecycle chaincode queryinstalled
Installed chaincodes on peer:
Package ID: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c, Label: fabcar_1
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=pear.farmer.com:8051
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:13:32.905 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:13:32.905 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# peer lifecycle chaincode queryinstalled
Installed chaincodes on peer:
Package ID: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c, Label: fabcar_1
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=melon.farmer.com:9051
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:13:39.618 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:13:39.618 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# peer lifecycle chaincode queryinstalled
Installed chaincodes on peer:
Package ID: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c, Label: fabcar_1
bash-4.4# 
bash-4.4# export PACKAGE_ID="${CHAINCODE_NAME}_${CHAINCODE_VERSION}:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c"
bash-4.4# peer lifecycle chaincode approveformyorg --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --waitForEvent --package-id ${PACKAGE_ID} --orderer orderer.farmer.com:7050
2019-10-12 05:13:51.136 UTC [chaincodeCmd] ClientWait -> INFO 001 txid [d9933ef8bd08601d7254afdb55792e12dad54f5552c48cc512201dfdfbef40ee] committed with status (VALID) at 
bash-4.4# 
bash-4.4# peer lifecycle chaincode queryapprovalstatus --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --orderer orderer.farmer.com:7050
{
	"Approved": {
		"FarmerMSP": true,
		"SupermarketMSP": false
	}
}
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# export CORE_PEER_LOCALMSPID=SupermarketMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:14:01.028 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:14:01.028 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer1.supermarket.com:13051
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:14:08.354 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:14:08.354 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# peer lifecycle chaincode queryinstalled
Installed chaincodes on peer:
Package ID: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c, Label: fabcar_1
bash-4.4# peer lifecycle chaincode approveformyorg --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --waitForEvent --package-id ${PACKAGE_ID} --orderer orderer.supermarket.com:7050
2019-10-12 05:14:16.995 UTC [chaincodeCmd] ClientWait -> INFO 001 txid [256a2b9a1e4693e936e2ea590512873ef2e8a0b5038efbdfbf4183aaa46559ab] committed with status (VALID) at 
bash-4.4# 
bash-4.4# peer lifecycle chaincode queryapprovalstatus --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --orderer orderer.supermarket.com:7050
{
	"Approved": {
		"FarmerMSP": true,
		"SupermarketMSP": true
	}
}
bash-4.4# 
bash-4.4# export PEERS_ADDRESSES='--peerAddresses apple.farmer.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt --peerAddresses peer0.supermarket.com:12051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt'
bash-4.4# peer lifecycle chaincode querycommitted -o orderer.supermarket.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} 
Error: query failed with status: 404 - namespace fabcar is not defined
bash-4.4# 
bash-4.4# peer lifecycle chaincode commit -o orderer.supermarket.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem --channelID retail-channel  ${PEERS_ADDRESSES} --name ${CHAINCODE_NAME} --init-required --version ${CHAINCODE_VERSION} --sequence ${CHAINCODE_SEQUENCE} 
2019-10-12 05:14:38.927 UTC [chaincodeCmd] ClientWait -> INFO 001 txid [e16621f6dc83e7d6f8dd03a71b56db6c1de905155565766d0e25f783fd9c36a5] committed with status (VALID) at peer0.supermarket.com:12051
2019-10-12 05:14:39.086 UTC [chaincodeCmd] ClientWait -> INFO 002 txid [e16621f6dc83e7d6f8dd03a71b56db6c1de905155565766d0e25f783fd9c36a5] committed with status (VALID) at apple.farmer.com:7051
bash-4.4# peer lifecycle chaincode querycommitted -o orderer.supermarket.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} 
Committed chaincode definition for chaincode 'fabcar' on channel 'retail-channel':
Version: 1, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc
bash-4.4# 
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
bash-4.4# export CHANNEL_NAME='retail-channel'
bash-4.4# peer chaincode invoke -o orderer.supermarket.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME} ${PEERS_ADDRESSES} --isInit --ctor '{"Args":[]}' 
2019-10-12 05:14:53.145 UTC [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200 
bash-4.4# peer chaincode invoke -o orderer.supermarket.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME} ${PEERS_ADDRESSES} -c '{"Args":["queryAllCars"]}' 
2019-10-12 05:14:56.142 UTC [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200 payload:"[]" 
bash-4.4# peer chaincode invoke -o orderer.supermarket.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME} ${PEERS_ADDRESSES} -c '{"Args":["initLedger"]}'
2019-10-12 05:14:59.599 UTC [chaincodeCmd] chaincodeInvokeOrQuery -> INFO 001 Chaincode invoke successful. result: status:200 
bash-4.4# peer chaincode query -o orderer.supermarket.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME}  -c '{"Args":["queryAllCars"]}' 
[{"Key":"CAR0", "Record":{"make":"Toyota","model":"Prius","colour":"blue","owner":"Tomoko"}},{"Key":"CAR1", "Record":{"make":"Ford","model":"Mustang","colour":"red","owner":"Brad"}},{"Key":"CAR2", "Record":{"make":"Hyundai","model":"Tucson","colour":"green","owner":"Jin Soo"}},{"Key":"CAR3", "Record":{"make":"Volkswagen","model":"Passat","colour":"yellow","owner":"Max"}},{"Key":"CAR4", "Record":{"make":"Tesla","model":"S","colour":"black","owner":"Adriana"}},{"Key":"CAR5", "Record":{"make":"Peugeot","model":"205","colour":"purple","owner":"Michel"}},{"Key":"CAR6", "Record":{"make":"Chery","model":"S22L","colour":"white","owner":"Aarav"}},{"Key":"CAR7", "Record":{"make":"Fiat","model":"Punto","colour":"violet","owner":"Pari"}},{"Key":"CAR8", "Record":{"make":"Tata","model":"Nano","colour":"indigo","owner":"Valeria"}},{"Key":"CAR9", "Record":{"make":"Holden","model":"Barina","colour":"brown","owner":"Shotaro"}}]

~~~


## Generate Crypto File for Transport ##

~~~
food-network-deploy haimhuan$ cd org-transport
org-transport ajonbin$ rm -rf crypto-config
org-transport haimhuan$ ../bin/cryptogen generate --config=./transport-crypto.yaml
transport.com
org-transport haimhuan$ cp -r ./crypto-config/* ../crypto-config/
org-transport haimhuan$ export FABRIC_CFG_PATH=$pwd && ../bin/configtxgen --printOrg TransportMSP > ../channel-artifacts/msp-transport.json
2019-10-12 13:15:51.845 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 13:15:51.848 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 002 Loaded configuration: /Users/haimhuan/farbic_2.0a/food-network-deploy/org-transport/configtx.yaml
org-transport haimhuan$ export FABRIC_CFG_PATH=$pwd && ../bin/configtxgen --printOrg OrdererTransport > ../channel-artifacts/orderer-transport.json
2019-10-12 13:15:52.000 CST [common.tools.configtxgen] main -> INFO 001 Loading configuration
2019-10-12 13:15:52.001 CST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 002 Loaded configuration: /Users/haimhuan/farbic_2.0a/food-network-deploy/org-transport/configtx.yaml
org-transport haimhuan$ cd ..
food-network-deploy haimhuan$ 
~~~

## Add Transport Orderer to System Channel ##

~~~
bash-4.4# export SYS_CHANNEL_NAME='food-sys-channel'
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=orderer.farmer.com:7050
bash-4.4# export CORE_PEER_LOCALMSPID=OrdererFarmer
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $SYS_CHANNEL_NAME --tls --cafile $ORDERER_CA
2019-10-12 05:16:26.274 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:16:26.276 UTC [cli.common] readBlock -> INFO 002 Received block: 1
2019-10-12 05:16:26.277 UTC [cli.common] readBlock -> INFO 003 Received block: 0
bash-4.4# 
bash-4.4# configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
bash-4.4# 
bash-4.4# jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"OrdererTransport":.[1]}}}}}' config.json ./channel-artifacts/orderer-transport.json > modified_config_application.json
bash-4.4# jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"OrdererTransport":.[1]}}}}}' modified_config_application.json ./channel-artifacts/orderer-transport.json > modified_config_orderer.json
bash-4.4# jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {"FoodConsortium": {"groups":{"TransportMSP":.[1]}}}}}}} * {"channel_group":{"groups":{"Consortiums":{"groups": {"RetailConsortium": {"groups":{"TransportMSP":.[2]}}}}}}}' modified_config_orderer.json  ./channel-artifacts/msp-transport.json  ./channel-artifacts/msp-transport.json > modified_config_consortium.json
: 7050,
    "server_tls_cert": "'${transport_tls_cert}'"
}]'
jq ".channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += ${consenter_transport}" modified_config_consortium.json > modified_config_consenter.json

host_transport_orderer='["orderer.transport.com:7050"]'
jq ".channel_group.values.OrdererAddresses.value.addresses += ${host_transport_orderer}" modified_config_consenter.json > modified_config_transport.json
bash-4.4# 
bash-4.4# 
bash-4.4# transport_tls_cert=$(base64 ./crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/tls/server.crt)
bash-4.4# consenter_transport='[{         
>     "client_tls_cert": "'${transport_tls_cert}'",
>     "host": "orderer.transport.com",
>     "port": 7050,
>     "server_tls_cert": "'${transport_tls_cert}'"
> }]'
bash-4.4# jq ".channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += ${consenter_transport}" modified_config_consortium.json > modified_config_consenter.json
bash-4.4# 
bash-4.4# host_transport_orderer='["orderer.transport.com:7050"]'
bash-4.4# jq ".channel_group.values.OrdererAddresses.value.addresses += ${host_transport_orderer}" modified_config_consenter.json > modified_config_transport.json
bash-4.4# 
bash-4.4# configtxlator proto_encode --input config.json --type common.Config --output config.pb
bash-4.4# configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
bash-4.4# configtxlator compute_update --channel_id $SYS_CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output orderer_transport_update.pb
o/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
bash-4.4# configtxlator proto_decode --input orderer_transport_update.pb --type common.ConfigUpdate | jq . > orderer_transport_update.json
bash-4.4# echo '{"payload":{"header":{"channel_header":{"channel_id":"food-sys-channel", "type":2}},"data":{"config_update":'$(cat orderer_transport_update.json)'}}}' | jq . > orderer_transport_update_in_envelope.json
bash-4.4# configtxlator proto_encode --input orderer_transport_update_in_envelope.json --type common.Envelope --output orderer_transport_update_in_envelope.pb
bash-4.4# peer channel signconfigtx -o orderer.farmer.com:7050 -f orderer_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
2019-10-12 05:16:47.488 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=orderer.supermarket.com:7050
bash-4.4# export CORE_PEER_LOCALMSPID=OrdererSupermarket
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel update -o orderer.supermarket.com:7050 -c $SYS_CHANNEL_NAME  -f orderer_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
2019-10-12 05:17:02.301 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:17:02.323 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
bash-4.4# 
bash-4.4# peer channel fetch config system-channel-latest.block -o orderer.supermarket.com:7050 -c $SYS_CHANNEL_NAME --tls --cafile $ORDERER_CA
2019-10-12 05:17:07.305 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:17:07.307 UTC [cli.common] readBlock -> INFO 002 Received block: 2
2019-10-12 05:17:07.309 UTC [cli.common] readBlock -> INFO 003 Received block: 2
bash-4.4# 
bash-4.4# cp system-channel-latest.block ./channel-artifacts/
bash-4.4# 
~~~

## Bring up Transport Nodes ##

~~~
food-network-deploy haimhuan$ docker-compose -f docker-compose-transport.yaml up -d
Creating volume "food-network_orderer.transport.com" with default driver
Creating volume "food-network_cargo.truck.transport.com" with default driver
Creating volume "food-network_refrigerated.truck.transport.com" with default driver
WARNING: Found orphan containers (pear.farmer.com, apple.farmer.com, melon.farmer.com, couchdb2, orderer.supermarket.com, fabric-cli, peer0.supermarket.com, couchdb0, orderer.farmer.com, peer1.supermarket.com, couchdb1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Creating refrigerated.truck.transport.com ... done
Creating cargo.truck.transport.com        ... done
Creating orderer.transport.com            ... done
~~~

## Add Transport Orderer to retail-channel ##

~~~
bash-4.4# export CHANNEL_NAME='retail-channel'
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=orderer.farmer.com:7050
bash-4.4# export CORE_PEER_LOCALMSPID=OrdererFarmer
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
2019-10-12 05:18:59.675 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:18:59.677 UTC [cli.common] readBlock -> INFO 002 Received block: 8
2019-10-12 05:18:59.680 UTC [cli.common] readBlock -> INFO 003 Received block: 2
bash-4.4# 
bash-4.4# configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
bash-4.4# 
bash-4.4# jq -s '.[0] * {"channel_group":{"groups":{"Orderer":{"groups": {"OrdererTransport":.[1]}}}}}' config.json ./channel-artifacts/orderer-transport.json > modified_config_orderer.json
bash-4.4# 
bash-4.4# transport_tls_cert=$(base64 ./crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/tls/server.crt)
bash-4.4# consenter_transport='[{         
>     "client_tls_cert": "'${transport_tls_cert}'",
>     "host": "orderer.transport.com",
>     "port": 7050,
>     "server_tls_cert": "'${transport_tls_cert}'"
> }]'
bash-4.4# jq ".channel_group.groups.Orderer.values.ConsensusType.value.metadata.consenters += ${consenter_transport}" modified_config_orderer.json > modified_config_consenter.json
bash-4.4# 
bash-4.4# host_transport_orderer='["orderer.transport.com:7050"]'
bash-4.4# jq ".channel_group.values.OrdererAddresses.value.addresses += ${host_transport_orderer}" modified_config_consenter.json > modified_config_transport.json
bash-4.4# 
bash-4.4# configtxlator proto_encode --input config.json --type common.Config --output config.pb
bash-4.4# 
bash-4.4# configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
bash-4.4# configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output org_transport_update.pb
bash-4.4# configtxlator proto_decode --input org_transport_update.pb --type common.ConfigUpdate | jq . > org_transport_update.json
bash-4.4# echo '{"payload":{"header":{"channel_header":{"channel_id":"retail-channel", "type":2}},"data":{"config_update":'$(cat org_transport_update.json)'}}}' | jq . > org_transport_update_in_envelope.json
bash-4.4# configtxlator proto_encode --input org_transport_update_in_envelope.json --type common.Envelope --output org_transport_update_in_envelope.pb
bash-4.4# peer channel signconfigtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
2019-10-12 05:19:25.235 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=orderer.supermarket.com:7050
bash-4.4# export CORE_PEER_LOCALMSPID=OrdererSupermarket
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel update -o orderer.supermarket.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
2019-10-12 05:19:37.864 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:19:37.886 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
bash-4.4# 
bash-4.4# 
~~~

## Add Transport MSP and Peers to retail-channel ##

~~~
bash-4.4# export CORE_PEER_ADDRESS=apple.farmer.com:7051
bash-4.4# export CORE_PEER_LOCALMSPID=FarmerMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/orderers/orderer.farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel fetch config config_block.pb -o orderer.farmer.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
2019-10-12 05:20:08.409 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:20:08.411 UTC [cli.common] readBlock -> INFO 002 Received block: 9
2019-10-12 05:20:08.412 UTC [cli.common] readBlock -> INFO 003 Received block: 9
bash-4.4# 
bash-4.4# configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
bash-4.4# 
bash-4.4# jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"TransportMSP":.[1]}}}}}' config.json ./channel-artifacts/msp-transport.json > modified_config_transport.json
bash-4.4# 
bash-4.4# configtxlator proto_encode --input config.json --type common.Config --output config.pb
gtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
bash-4.4# configtxlator proto_encode --input modified_config_transport.json --type common.Config --output modified_config_transport.pb
bash-4.4# configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config_transport.pb --output org_transport_update.pb
bash-4.4# configtxlator proto_decode --input org_transport_update.pb --type common.ConfigUpdate | jq . > org_transport_update.json
bash-4.4# echo '{"payload":{"header":{"channel_header":{"channel_id":"retail-channel", "type":2}},"data":{"config_update":'$(cat org_transport_update.json)'}}}' | jq . > org_transport_update_in_envelope.json
bash-4.4# configtxlator proto_encode --input org_transport_update_in_envelope.json --type common.Envelope --output org_transport_update_in_envelope.pb
bash-4.4# peer channel signconfigtx -o orderer.farmer.com:7050 -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 
2019-10-12 05:20:18.136 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
bash-4.4# export CORE_PEER_LOCALMSPID=SupermarketMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/orderers/orderer.supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem'
bash-4.4# peer channel update -o orderer.supermarket.com:7050 -c $CHANNEL_NAME  -f org_transport_update_in_envelope.pb --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
2019-10-12 05:20:24.370 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:20:24.389 UTC [channelCmd] update -> INFO 002 Successfully submitted channel update
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
bash-4.4# export CORE_PEER_LOCALMSPID=TransportMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'
bash-4.4# 
bash-4.4# peer channel fetch 0 retail-channel-0.block -o orderer.transport.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
2019-10-12 05:20:48.296 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:20:48.305 UTC [cli.common] readBlock -> INFO 002 Received block: 0
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
bash-4.4# peer channel join -b ./retail-channel-0.block 
2019-10-12 05:20:53.677 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:20:53.755 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# 
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:20:57.138 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:20:58.195 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:20:58.926 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:20:59.495 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:21:00.027 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Blockchain info: {"height":11,"currentBlockHash":"mdlqRAcFzLXs9GPZ3pDnrm60XBmpkW0vWYrBAtV3N1s=","previousBlockHash":"grkSrfRB9dgCXOSl8fuL61FBNowrnjuzHEY/sdWi2N8="}
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:21:00.558 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Blockchain info: {"height":11,"currentBlockHash":"mdlqRAcFzLXs9GPZ3pDnrm60XBmpkW0vWYrBAtV3N1s=","previousBlockHash":"grkSrfRB9dgCXOSl8fuL61FBNowrnjuzHEY/sdWi2N8="}
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=refrigerated.truck.transport.com:15051
bash-4.4# peer channel join -b ./retail-channel-0.block 
2019-10-12 05:21:07.958 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
2019-10-12 05:21:08.009 UTC [channelCmd] executeJoin -> INFO 002 Successfully submitted proposal to join channel
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:21:12.268 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:21:13.532 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Error: received bad response, status 500: access denied for [GetChainInfo][retail-channel]: [Failed evaluating policy on signed data during check policy on channel [retail-channel] with policy [/Channel/Application/Readers]: [implicit policy evaluation failed - 0 sub-policies were satisfied, but this policy requires 1 of the 'Readers' sub-policies to be satisfied]]
bash-4.4# peer channel getinfo -c ${CHANNEL_NAME}
2019-10-12 05:21:14.916 UTC [channelCmd] InitCmdFactory -> INFO 001 Endorser and orderer connections initialized
Blockchain info: {"height":11,"currentBlockHash":"mdlqRAcFzLXs9GPZ3pDnrm60XBmpkW0vWYrBAtV3N1s=","previousBlockHash":"grkSrfRB9dgCXOSl8fuL61FBNowrnjuzHEY/sdWi2N8="}
bash-4.4# 
bash-4.4# 

~~~

## Install and Invoke Chaincode on Transport Peers ##

~~~
bash-4.4# export CHAINCODE_VERSION=1
bash-4.4# export CHAINCODE_NAME=fabcar
bash-4.4# export CHAINCODE_SEQUENCE=1
bash-4.4# export CHANNEL_NAME=r'etail-channel'
bash-4.4# 
bash-4.4# 
bash-4.4# export CORE_PEER_ADDRESS=cargo.truck.transport.com:14051
bash-4.4# export CORE_PEER_LOCALMSPID=TransportMSP
bash-4.4# export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.crt
bash-4.4# export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/server.key
bash-4.4# export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/peers/cargo.truck.transport.com/tls/ca.crt
bash-4.4# export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/transport.com/users/Admin@transport.com/msp
bash-4.4# 
bash-4.4# peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
2019-10-12 05:22:26.269 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 001 Installed remotely: response:<status:200 payload:"\nIfabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c\022\010fabcar_1" > 
2019-10-12 05:22:26.269 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 002 Chaincode code package identifier: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c
bash-4.4# peer lifecycle chaincode queryinstalled
Installed chaincodes on peer:
Package ID: fabcar_1:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c, Label: fabcar_1
bash-4.4# export PACKAGE_ID="${CHAINCODE_NAME}_${CHAINCODE_VERSION}:34e1d967ab04f9d30d12aad055e3596f7bb6e929839b3914852cf337b56c226c"
bash-4.4# export ORDERER_CA='/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem'
bash-4.4# 
bash-4.4# peer lifecycle chaincode approveformyorg --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem --channelID retail-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --waitForEvent --package-id ${PACKAGE_ID} --orderer orderer.transport.com:7050
2019-10-12 05:22:37.467 UTC [chaincodeCmd] ClientWait -> INFO 001 txid [5a757171bdfc2e552adbf3a02d2fa15b5c9ef322e4c2d70d13107a656be33eab] committed with status (VALID) at 
bash-4.4# peer lifecycle chaincode queryapprovalstatus --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/transport.com/orderers/orderer.transport.com/msp/tlscacerts/tlsca.transport.com-cert.pem --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --init-required --sequence ${CHAINCODE_SEQUENCE} --orderer orderer.transport.com:7050
Error: bad response: 500 - failed to invoke backing implementation of 'QueryApprovalStatus': requested sequence is 1, but new definition must be sequence 2
bash-4.4# peer chaincode query -o orderer.transport.com:7050 --tls true  --cafile ${ORDERER_CA} --channelID $CHANNEL_NAME --name ${CHAINCODE_NAME}  -c '{"Args":["queryAllCars"]}' 
[{"Key":"CAR0", "Record":{"make":"Toyota","model":"Prius","colour":"blue","owner":"Tomoko"}},{"Key":"CAR1", "Record":{"make":"Ford","model":"Mustang","colour":"red","owner":"Brad"}},{"Key":"CAR2", "Record":{"make":"Hyundai","model":"Tucson","colour":"green","owner":"Jin Soo"}},{"Key":"CAR3", "Record":{"make":"Volkswagen","model":"Passat","colour":"yellow","owner":"Max"}},{"Key":"CAR4", "Record":{"make":"Tesla","model":"S","colour":"black","owner":"Adriana"}},{"Key":"CAR5", "Record":{"make":"Peugeot","model":"205","colour":"purple","owner":"Michel"}},{"Key":"CAR6", "Record":{"make":"Chery","model":"S22L","colour":"white","owner":"Aarav"}},{"Key":"CAR7", "Record":{"make":"Fiat","model":"Punto","colour":"violet","owner":"Pari"}},{"Key":"CAR8", "Record":{"make":"Tata","model":"Nano","colour":"indigo","owner":"Valeria"}},{"Key":"CAR9", "Record":{"make":"Holden","model":"Barina","colour":"brown","owner":"Shotaro"}}]

~~~