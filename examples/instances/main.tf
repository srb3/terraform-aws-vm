variable "aws_creds_file" {
  description = "The path to an aws credentials file"
  type        = string
}

variable "aws_profile" {
  description = "The name of an aws profile to use"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The aws region to use"
  type        = string
  default     = "eu-west-1"
}

variable "aws_key_name" {
  description = "The name of an aws key pair to use for the vms"
  type        = string
}

variable "tags" {
  description = "A set of tags to assign to the instances created by this module"
  type        = map(string)
  default     = {}
}

variable "ingress_cidrs" {
  description = "A list of CIDR's to use for allowing access to the vms"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "private_key" {
  description = "The ssh private key used to access the windows password, must match the aws_key_name public key"
  type        = string
}

provider "aws" {
  shared_credentials_file = var.aws_creds_file
  profile                 = var.aws_profile
  region                  = var.aws_region
}

data "aws_availability_zones" "available" {}

module "linux_ami" {
  source  = "srb3/ami/aws"
  version = "0.13.0"
  os_name = "centos-7"
}

module "windows_ami" {
  source  = "srb3/ami/aws"
  version = "0.13.0"
  os_name = "windows-2019"
}

resource "random_id" "hash" {
  byte_length = 4
}

locals {
  public_subnets = ["10.0.1.0/24"]
  azs            = [
                     data.aws_availability_zones.available.names[0],
                     data.aws_availability_zones.available.names[1]
                   ]
  linux_ingress_rules = ["ssh-tcp"]
  linux_egress_rules  = ["all-all"]
  linux_egress_cidrs  = ["0.0.0.0/0"]
  linux_instance_type = "t3.small"
  linux_rbd           = [{ volume_type = "gp2", volume_size = "40" }]

  windows_ingress_rules = ["winrm-http-tcp", "winrm-https-tcp", "rdp-tcp", "rdp-udp"]
  windows_egress_rules  = ["all-all"]
  windows_egress_cidrs = ["0.0.0.0/0"]
  windows_instance_type = "t3.medium"
  windows_rbd           = [{ volume_type = "gp2", volume_size = "40" }]

  sg_data = {
    "linux" = {
      "ingress_rules" = local.linux_ingress_rules,
      "ingress_cidr"  = var.ingress_cidrs,
      "egress_rules"  = local.linux_egress_rules,
      "egress_cidr"   = local.linux_egress_cidrs,
      "description"   = "linux security group"
      "vpc_id"        = module.vpc.vpc_id
    },
    "windows" = {
      "ingress_rules" = local.windows_ingress_rules,
      "ingress_cidr"  = var.ingress_cidrs,
      "egress_rules"  = local.windows_egress_rules,
      "egress_cidr"   = local.windows_egress_cidrs,
      "description"   = "windows security group"
      "vpc_id"        = module.vpc.vpc_id
    }
  }

  vm_data = {
    "linux" = {
      "ami"                = module.linux_ami.id,
      "instance_type"      = local.linux_instance_type,
      "key_name"           = var.aws_key_name,
      "security_group_ids" = [module.security_group["linux"].id],
      "subnet_ids"         = module.vpc.public_subnets,
      "root_block_device"  = local.linux_rbd,
      "public_ip_address"  = true,
      "get_password_data"  = false
    },
    "windows" = {
      "ami"                = module.windows_ami.id,
      "instance_type"      = local.windows_instance_type,
      "key_name"           = var.aws_key_name,
      "security_group_ids" = [module.security_group["windows"].id],
      "subnet_ids"         = module.vpc.public_subnets,
      "root_block_device"  = local.windows_rbd,
      "public_ip_address"  = true,
      "get_password_data"  = true
    }
  }
}

module "vpc" {
  source         = "srb3/vpc/aws"
  version        = "0.13.0"
  name           = "Automate and Squid vpc"
  cidr           = "10.0.0.0/16"
  azs            = local.azs
  public_subnets = local.public_subnets
  tags           = var.tags
}

module "security_group" {
  source              = "srb3/security-group/aws"
  version             = "0.13.1"
  for_each            = local.sg_data
  name                = each.key
  description         = each.value["description"]
  vpc_id              = each.value["vpc_id"]
  ingress_rules       = each.value["ingress_rules"]
  ingress_cidr_blocks = each.value["ingress_cidr"]
  egress_rules        = each.value["egress_rules"]
  egress_cidr_blocks  = each.value["egress_cidr"]
  tags                = var.tags
}

module "instance" {
  source                      = "../../"
  for_each                    = local.vm_data
  name                        = each.key
  ami                         = each.value["ami"]
  instance_type               = each.value["instance_type"]
  key_name                    = each.value["key_name"]
  security_group_ids          = each.value["security_group_ids"]
  subnet_ids                  = each.value["subnet_ids"]
  root_block_device           = each.value["root_block_device"]
  associate_public_ip_address = each.value["public_ip_address"] 
  get_password_data           = each.value["get_password_data"]
  tags                        = var.tags
}
