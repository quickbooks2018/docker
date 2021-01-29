#!/bin/bash
#Maintainer: Muhammad Asim <quickbooks2018@gmail.com>
# OS: AmazonLinux
# Note: Scripts are created in Windows environment, to run these in Linux/Unix based OS ---> use dos2unix


# Create a Key from Console

ALIAS_NAME_KMS_KEY_ID='fd7965c1-532d-4b3c-8678-e5a2e9d4a19f'


mkdir -p /root/secrets/postgres


# Encryption
aws kms encrypt --region us-east-1 --key-id $ALIAS_NAME_KMS_KEY_ID  --plaintext postgres --output text --query CiphertextBlob | base64 --decode > /root/secrets/postgres/postgres-database.txt
aws kms encrypt --region us-east-1 --key-id $ALIAS_NAME_KMS_KEY_ID  --plaintext postgres --output text --query CiphertextBlob | base64 --decode > /root/secrets/postgres/postgres-user.txt
aws kms encrypt --region us-east-1 --key-id $ALIAS_NAME_KMS_KEY_ID  --plaintext 12345678 --output text --query CiphertextBlob | base64 --decode > /root/secrets/postgres/postgres-password.txt



# Decryption
aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-database.txt --output text --query Plaintext | base64 --decode
aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-user.txt --output text --query Plaintext | base64 --decode
aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-password.txt  --output text --query Plaintext | base64 --decode
#END


POSTGRES_DB=`aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-database.txt --output text --query Plaintext | base64 --decode`
POSTGRES_USER=`aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-user.txt --output text --query Plaintext | base64 --decode`
POSTGRES_PASSWORD=`aws kms decrypt --region us-east-1 --ciphertext-blob fileb:///root/secrets/postgres/postgres-password.txt  --output text --query Plaintext | base64 --decode`


echo "\n"
echo "Credentials Decrypted"


echo " This is postgres database name  = $POSTGRES_DB "
echo " This is postgres User = $POSTGRES_USER "
echo " This is postgres password = $POSTGRES_PASSWORD "


