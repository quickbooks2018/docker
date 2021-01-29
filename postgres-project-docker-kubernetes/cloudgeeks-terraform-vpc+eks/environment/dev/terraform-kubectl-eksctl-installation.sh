#!/bin/bash
# OS: AmazonLinux
# Note: Scripts are created in Windows environment, to run these in Linux/Unix based OS ---> use dos2unix

# Terraform Installation
curl -LO https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip
unzip terraform_0.14.3_linux_amd64.zip
rm -f terraform_0.14.3_linux_amd64.zip
mv terraform /usr/bin/terraform

# Kubectl Installation
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl

mv ./kubectl /usr/bin/kubectl


# EKSCTL Installation
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin/eksctl
eksctl version


#END