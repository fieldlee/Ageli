ORG1_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjM0NTE0MzEsInVzZXJuYW1lIjoiSmltIiwib3JnTmFtZSI6Im9yZzEiLCJpYXQiOjE1MjM0MTU0MzF9.ljY7b_T40mKGY1QPsJ6o02f0G7kB6evjyXphybRT9Mw"
ORG2_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjM0NDg5NzUsInVzZXJuYW1lIjoiQmFycnkiLCJvcmdOYW1lIjoib3JnMiIsImlhdCI6MTUyMzQxMjk3NX0.hZKtPUTYw1tC-OenyN9pEKM85YyrL91QXh5R-h9XlTA"
echo
echo "ORG2 token is $ORG2_TOKEN"
echo "POST invoke chaincode on peers of Org1 and Org2"
echo
# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels/mychannel/chaincodes/mycc \
#   -H "authorization: Bearer $ORG2_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
# 	"fcn":"move",
# 	"args":["a","b","10"]
# }')
# echo "Transacton ID is $TRX_ID"
# echo

# TRX_ID=$(curl -s -X POST \
#   http://localhost:4000/channels/mychannel/chaincodes/mycc \
#   -H "authorization: Bearer $ORG1_TOKEN" \
#   -H "content-type: application/json" \
#   -d '{
# 	"fcn":"move",
# 	"args":["a","b","20"]
# }')
# echo "Transacton ID is $TRX_ID"
# echo


echo "GET query chaincode on peer1 of Org2"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query chaincode on peer2 of Org2"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer2&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo

echo "GET query chaincode on peer2 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/mychannel/chaincodes/mycc?peer=peer2&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo