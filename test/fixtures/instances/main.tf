module "instances" {
  source         = "../../../examples/instances"
  aws_region     = var.aws_region
  aws_profile    = var.aws_profile
  aws_creds_file = var.aws_creds_file
  aws_key_name   = var.aws_key_name
  ingress_cidrs  = var.ingress_cidrs
  private_key    = var.private_key
  tags           = var.tags
}
