module "aws" {
  source              = "./modules/aws"
  number_of_instances = var.number_of_instances
  instance_type       = var.instance_type
  key_name            = var.key_name
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_az   = var.private_subnet_az
  public_subnet_cidr  = var.public_subnet_cidr
  public_subnet_az    = var.public_subnet_az
}
