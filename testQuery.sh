


echo "POST invoke chaincode on peers of Ageli and Creator"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/agelichannel/chaincodes/hlccc \
  -H "authorization: Bearer $Ageli_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"fcn":"move",
	"args":["a","b","10"]
}')
echo "Transacton ID is $TRX_ID"
echo
echo