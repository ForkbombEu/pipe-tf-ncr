#!/bin/bash

# Read DNS from pipe redirected stdin
DNS=$(grep -oP 'instance_public_dns\s*=\s*"\K[^"]+')
# Verify if DNS is found
if [ -z "$DNS" ]; then
    echo "Error: DNS not found in the output"
    exit 1
fi
echo "Found DNS: $DNS"

# Copy code to be executed on server
sleep 10
echo "Upload serverSideEC2Code.sh"
scp -o StrictHostKeyChecking=no -i ./../testRsaKey ./../../serverSideEC2Code.sh admin@"$DNS": 
# Verify SCP correctness
if [ $? -ne 0 ]; then
    echo "Error: failed SCP of ./serverSideEC2Code.sh"
    exit 1
fi

# Compress folder to be uploaded in EC2
echo "Compress int_didroom_issuer1"
tar -czf ./../../int_didroom_issuer1.tar.gz ./../../microservices/int_didroom_issuer1
if [ $? -ne 0 ]; then
    echo "Error: failed tar.gz"
    exit 1
fi

# Copy zip microservices issuer folder to the EC" server
echo "Upload int_didroom_issuer1.tar.gz"
scp -o StrictHostKeyChecking=no -i ./../testRsaKey ./../../int_didroom_issuer1.tar.gz admin@"$DNS": 
# Verify SCP comand correctness
if [ $? -ne 0 ]; then
    echo "Error: failed SCP of ./int_didroom_issuer1.tar.gz"
    exit 1
fi

#remove local zip copy file
echo "Remove local copy of int_didroom_issuer1.tar.gz"
rm ./../../int_didroom_issuer1.tar.gz


# Execute server side the uploaded code
echo "Start script server side via SSH"
ssh -o StrictHostKeyChecking=no -i ./../testRsaKey admin@"$DNS" "bash ./serverSideEC2Code.sh $DNS"
# Verify SSH comand correctness
if [ $? -ne 0 ]; then
    echo "Errore: SSH fallito."
    exit 1
fi
