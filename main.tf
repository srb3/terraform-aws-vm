module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.15.0"
  name                        = var.name
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  subnet_ids                  = var.subnet_ids
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  root_block_device           = var.root_block_device
  ebs_block_device            = var.ebs_block_device
  ephemeral_block_device      = var.ephemeral_block_device
  associate_public_ip_address = var.associate_public_ip_address
  get_password_data           = var.get_password_data
  tags                        = var.tags
}
