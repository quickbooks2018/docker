provider "aws" {
  region = "us-east-1"
}

### Backend ###
# S3
###############

terraform {
  backend "s3" {
    bucket = "cloudgeeks-terraform"
    key = "cloudgeeks.tfstate"
    region = "us-east-1"
  }
}
module "vpc" {
  source = "../../modules/vpc"
  vpc-location                        = "Virginia"
  namespace                           = "cloudgeeks"
  name                                = "vpc"
  stage                               = "dev"
  map_public_ip_on_launch             = "false"
  total-nat-gateway-required          = "1"
  create_database_subnet_group        = "true"
  vpc-cidr                            = "10.11.0.0/16"
  vpc-public-subnet-cidr              = ["10.11.1.0/24","10.11.2.0/24","10.11.3.0/24","10.11.4.0/24","10.11.5.0/24","10.11.6.0/24"]
  vpc-private-subnet-cidr             = ["10.11.11.0/24","10.11.12.0/24","10.11.13.0/24","10.11.14.0/24","10.11.15.0/24","10.11.16.0/24"]
  vpc-database_subnets-cidr           = ["10.11.21.0/24","10.11.22.0/24","10.11.23.0/24","10.11.24.0/24","10.11.25.0/24","10.11.26.0/24"]
  cluster-name                        = "cloudgeeks-eks"
}
