#!/bin/bash
set -x
rm -rf crypto-config
bin/cryptogen generate --config=./crypto-config.yaml
mkdir -p channel-artifacts
rm -rf channel-artifacts/*
bin/configtxgen -profile FoodWithEtcdRaft -channelID food-sys-channel -outputBlock ./channel-artifacts/genesis.block
bin/configtxgen -profile RetailChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID retail-channel
bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/FarmerMSPanchors.tx -channelID retail-channel -asOrg FarmerMSP
bin/configtxgen -profile RetailChannel -outputAnchorPeersUpdate ./channel-artifacts/SupermarketMSPanchors.tx -channelID retail-channel -asOrg SupermarketMSP


