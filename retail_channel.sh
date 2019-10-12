export CORE_PEER_ADDRESS=apple.farmer.com:7051
export CORE_PEER_LOCALMSPID=FarmerMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp
peer channel create -o orderer.farmer.com:7050 -c retail-channel -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem

export CORE_PEER_ADDRESS=apple.farmer.com:7051
peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block 

export CORE_PEER_ADDRESS=pear.farmer.com:8051
peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block

export CORE_PEER_ADDRESS=melon.farmer.com:9051
peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block

export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
export CORE_PEER_LOCALMSPID=SupermarketMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp

export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block

export CORE_PEER_ADDRESS=peer1.supermarket.com:13051
peer channel join -b /opt/gopath/src/github.com/hyperledger/fabric/peer/retail-channel.block

export CORE_PEER_ADDRESS=apple.farmer.com:7051
export CORE_PEER_LOCALMSPID=FarmerMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/peers/apple.farmer.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/farmer.com/users/Admin@farmer.com/msp

peer channel update -o orderer.farmer.com:7050 -c retail-channel  -f channel-artifacts/FarmerMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/farmer.com/msp/tlscacerts/tlsca.farmer.com-cert.pem 

export CORE_PEER_ADDRESS=peer0.supermarket.com:12051
export CORE_PEER_LOCALMSPID=SupermarketMSP
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/peers/peer0.supermarket.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/supermarket.com/users/Admin@supermarket.com/msp

peer channel update -o orderer.supermarket.com:7050 -c retail-channel  -f channel-artifacts/SupermarketMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/supermarket.com/msp/tlscacerts/tlsca.supermarket.com-cert.pem 
