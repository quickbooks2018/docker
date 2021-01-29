#!/bin/bash
#Purpose: Creation of an S3 Bucket for Terraform backend
# OS: AmazonLinux
# Note: Scripts are created in Windows environment, to run these in Linux/Unix based OS ---> use dos2unix

BUCKETNAME="cloudgeeks-terraform"

aws s3api create-bucket --bucket "$BUCKETNAME" --region us-east-1

aws s3api put-bucket-versioning --bucket "$BUCKETNAME" --versioning-configuration Status=Enabled

#END
