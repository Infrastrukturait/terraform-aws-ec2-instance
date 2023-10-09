data "aws_availability_zones" "available" {}

locals {
  vpc_cidr      = "10.0.0.0/16"
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)
  instance_type = "t3.micro"
  ami_id        = "ami-0f845a2bba44d24b2"
}

module "app_prod_bastion_label" {
  source  = "cloudposse/label/null"
  version = "v0.25.0"

  namespace  = "app"
  stage      = "prod"
  name       = "bastion"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v5.1.2"

  name = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name, "vpc"])

  cidr = local.vpc_cidr
  azs  = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  tags = module.app_prod_bastion_label.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name, "sg"])
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = module.app_prod_bastion_label.tags
}

module "eip" {
  source  = "Infrastrukturait/eip/aws"
  version = "0.1.0"

  name = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name])
  tags = module.app_prod_bastion_label.tags
}

module "ec2_instance_with_eip" {
  source = "../../"

  name = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name])

  ami                    = local.ami_id
  instance_type          = local.instance_type
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]

  associate_public_ip_address = true
  assign_eip_address          = true
  eip_adress_allocation_id    = module.eip.id

  enable_volume_tags = false

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  tags = merge(
    module.app_prod_bastion_label.tags,
    {
      "Allocation-Eip-Id" = module.eip.id
    }
  )
}
