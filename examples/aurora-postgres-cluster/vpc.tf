provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "1.2.0"

  ipv4_primary_cidr_block = "10.120.0.0/22"

}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.4"

  availability_zones   = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false
}