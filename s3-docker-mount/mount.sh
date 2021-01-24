#!/bin/bash
#Purpose: S3 Mount via Access Keys
#Maintainer: Muhammad Asim <quickbook2018@gmail.com>
# OS: Ubuntu/Mac
# S3: Permissions Level Full Access

bucket_name=cloudgeeksmedia
ACCESS_KEY_ID=AKGGSGSGAGAGLBFDAEKL3T4MG
SECRET_ACCESS_KEY=LLSKSKSKKDQRFehssssshshIdx0pMu7wfNMZHMCCLLLLSSKCT
mount_point=""$PWD"/"$bucket_name""



echo ""$ACCESS_KEY_ID":"$SECRET_ACCESS_KEY"" > ${HOME}/.passwd-s3fs
chmod 600 ${HOME}/.passwd-s3fs

mkdir -p $mount_point


/usr/local/bin/s3fs "$bucket_name" "$mount_point" -o passwd_file=${HOME}/.passwd-s3fs -o allow_other -o use_path_request_style -o nonempty

/usr/local/bin/s3fs "$bucket_name" "$mount_point" -o passwd_file=${HOME}/.passwd-s3fs -o allow_other -o use_path_request_style o dbglevel=info -f -o curldbg




#DEBUG -o dbglevel=info -f -o curldbg
#PATH  -o url="https://s3.us-east-1.amazonaws.com"
# cat /etc/fuse.conf

#END