#!/usr/bin/env bash

echo "POST instantiate chaincode on Org1"
echo
curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes \
  -H "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDQ2MTY4ODIsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoiT3JnMiIsImlhdCI6MTU0NDU4MDg4Mn0.8V_rTLSdecqNbuC5X03fFpCFHhcF1W7FQdOvj3KmSHw" \
  -H "content-type: application/json" \
  -d "{
	\"chaincodeName\":\"mycc\",
	\"chaincodeVersion\":\"v0\",
	\"chaincodeType\": \"golang\",
	\"fcn\": \"init\"
}"
echo
echo

echo "POST invoke chaincode on peers of Org1 and Org2"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel/chaincodes/mycc \
  -H "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDQ2MTY4ODIsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoiT3JnMiIsImlhdCI6MTU0NDU4MDg4Mn0.8V_rTLSdecqNbuC5X03fFpCFHhcF1W7FQdOvj3KmSHw" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer0.org1.example.com","peer0.org2.example.com"],
	"fcn":"initMarble",
	"args":["记账","收入","10","lin"]
}')
echo "Transaction ID is $TRX_ID"
echo
echo

echo "GET query Block by blockNumber"
echo
BLOCK_INFO=$(curl -s -X GET \
  "http://localhost:4000/channels/mychannel/blocks/1?peer=peer0.org1.example.com" \
  -H "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDQ2MTY4ODIsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoiT3JnMiIsImlhdCI6MTU0NDU4MDg4Mn0.8V_rTLSdecqNbuC5X03fFpCFHhcF1W7FQdOvj3KmSHw" \
  -H "content-type: application/json")
echo $BLOCK_INFO
# Assign previvious block hash to HASH
HASH=$(echo $BLOCK_INFO | jq -r ".header.previous_hash")
echo

echo "GET query Transaction by TransactionID"
echo
curl -s -X GET http://localhost:4000/channels/mychannel/transactions/$TRX_ID?peer=peer0.org1.example.com \
  -H "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDQ2MTY4ODIsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoiT3JnMiIsImlhdCI6MTU0NDU4MDg4Mn0.8V_rTLSdecqNbuC5X03fFpCFHhcF1W7FQdOvj3KmSHw" \
  -H "content-type: application/json"
echo
echo

