#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on Ageli  ..."
echo
Ageli_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=ageli&password=password&orgName=Ageli')
echo $Ageli_TOKEN
Ageli_TOKEN=$(echo $Ageli_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $Ageli_TOKEN"
echo
echo "POST request Enroll on Creator ..."
echo
Creator_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=creator&password=password&orgName=Creator')
echo $Creator_TOKEN
Creator_TOKEN=$(echo $Creator_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Creator token is $Creator_TOKEN"
echo
echo "POST request Enroll on Transfer ..."
echo
Transfer_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=transfer&password=password&orgName=Transfer')
echo $Transfer_TOKEN
Transfer_TOKEN=$(echo $Transfer_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Transfer token is $Transfer_TOKEN"
echo


echo
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"agelichannel",
	"channelConfigPath":"../artifacts/channel/channel.tx"
}'
echo
echo

sleep 5


echo "POST request Join channel on Ageli"
echo
curl -s -X POST \
  http://localhost:4000/channels/agelichannel/peers \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
}'
echo
echo

echo "POST request Join channel on Creator"
echo
curl -s -X POST \
  http://localhost:4000/channels/agelichannel/peers \
  -H "authorization: Bearer $Creator_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo


echo "POST request Join channel on Transfer"
echo
curl -s -X POST \
  http://localhost:4000/channels/agelichannel/peers \
  -H "authorization: Bearer $Transfer_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo

echo "POST Install chaincode on Ageli"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1", "peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"github.com/example_cc",
	"chaincodeVersion":"v0"
}'
echo
echo


echo "POST Install chaincode on Creator"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Creator_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"github.com/example_cc",
	"chaincodeVersion":"v0"
}'
echo
echo

echo "POST Install chaincode on Transfer"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $Transfer_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"],
	"chaincodeName":"hlccc",
	"chaincodePath":"github.com/example_cc",
	"chaincodeVersion":"v0"
}'
echo
echo

echo "POST instantiate chaincode on peer1 of Ageli"
echo
curl -s -X POST \
  http://localhost:4000/channels/agelichannel/chaincodes \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"hlccc",
	"chaincodeVersion":"v0",
	"args":["a","100","b","200"]
}'
echo
echo

# echo "POST invoke chaincode on peers of Ageli and Creator"
# echo
# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels/agelichannel/chaincodes/hlccc \
#   -H "authorization: Bearer $Ageli_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
# 	"fcn":"move",
# 	"args":["a","b","10"]
# }')
# echo "Transacton ID is $TRX_ID"
# echo
# echo

echo "GET query chaincode on peer1 of Ageli"
echo
curl -s -X GET \
  "http://localhost:4000/channels/agelichannel/chaincodes/hlccc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Block by blockNumber"
echo
curl -s -X GET \
  "http://localhost:4000/channels/agelichannel/blocks/1?peer=peer1" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo

# echo "GET query Transaction by TransactionID on peero in Ageli"
# echo
# curl -s -X GET http://localhost:4000/channels/agelichannel/transactions/$TRX_ID?peer=peer1 \
#   -H "authorization: Bearer $Ageli_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo


# echo "GET query Transaction by TransactionID on peer1 in Ageli"
# echo
# curl -s -X GET http://localhost:4000/channels/agelichannel/transactions/$TRX_ID?peer=peer1 \
#   -H "authorization: Bearer $Ageli_TOKEN" \
#   -H "content-type: application/json"
# echo
# echo

############################################################################
### TODO: What to pass to fetch the Block information
############################################################################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:4000/channels/mychannel/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

echo "GET query ChainInfo on Ageli peer1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/agelichannel?peer=peer1" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=installed" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query Channels"
echo
curl -s -X GET \
  "http://localhost:4000/channels?peer=peer1" \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
