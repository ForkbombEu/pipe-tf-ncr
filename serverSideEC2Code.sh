#!/bin/bash
#install necessary packages
sleep 2
sudo apt-get update 
sudo apt-get install make jq netcat-openbsd -y

# Ensure the DNS is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <dns>"
  exit 1
fi
DNS=$1

# test file to semonstrate the code was executed server side
echo "log: codice.sh was executed and recieved ad parameter the DNS: $DNS
" >> debugLog.log



#unzip microservice and remove the copy
tar -xzf int_didroom_issuer1.tar.gz 
rm ./int_didroom_issuer1.tar.gz



#substitute the url in the config file
JSON_FILE="./microservices/int_didroom_issuer1/public/credential_issuer/.well-known/openid-credential-issuer"  # The JSON file to modify

# Prefix the DNS with http:// and update the values in the JSON
jq --arg dns "$DNS" '
  .credential_issuer = "http://" + $dns + "/credential_issuer" |
  .credential_endpoint = "http://" + $dns + "/credential_issuer/credential" |
  .authorization_servers = ["http://" + $dns + "/authz_server"]
' "$JSON_FILE" > tmp.$$.json && mv tmp.$$.json "$JSON_FILE"

if [ $? -eq 0 ]; then
  echo "JSON file updated successfully.
  " >> debugLog.log
else
  echo "jq command failed
  " >> debugLog.logg
  exit 1
fi



#run the microservice
cd microservices/int_didroom_issuer1/
make > ./../../debugLog_makeStdout.log 2> ./../../debugLog_makeStderr.log  &
echo "log: ran int_didroom_issuer1 make file
" >> ./../../debugLog.log