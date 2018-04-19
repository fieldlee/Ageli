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
  -d 'username=transfer_01&password=password&orgName=Transfer')
echo $Ageli_TOKEN
Ageli_TOKEN=$(echo $Ageli_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $Ageli_TOKEN"
echo
echo "POST request Enroll on Creator ..."
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