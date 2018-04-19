

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
echo "Total execution time : $(($(date +%s)-starttime)) secs ..."