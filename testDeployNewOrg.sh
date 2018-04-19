jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on Seller ..."
echo
Seller_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=seller&password=password&orgName=Seller')
echo $Seller_TOKEN
Seller_TOKEN=$(echo $Seller_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "Transfer token is $Seller_TOKEN"
echo

echo "POST request Join channel on Seller"
echo
curl -s -X POST \
  http://localhost:4000/channels/agelichannel/peers \
  -H "authorization: Bearer $Seller_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["peer1","peer2"]
  }'
echo
echo

echo "POST Install chaincode on Seller"
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
echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
