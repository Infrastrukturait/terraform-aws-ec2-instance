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

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]

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

module "ebs_volume_a" {
  source            = "Infrastrukturait/ebs-volume/aws"
  version           = "0.3.0"
  name              = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name, "ebs-a"])
  size              = 10
  availability_zone = element(module.vpc.azs, 0)
  tags              = module.app_prod_bastion_label.tags
}

module "ebs_volume_b" {
  source            = "Infrastrukturait/ebs-volume/aws"
  version           = "0.3.0"
  name              = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name, "ebs-b"])
  size              = 10
  availability_zone = element(module.vpc.azs, 0)
  tags              = module.app_prod_bastion_label.tags
}

module "ec2_instance" {
  source = "../../"

  name = join(module.app_prod_bastion_label.delimiter, [module.app_prod_bastion_label.stage, module.app_prod_bastion_label.name, var.name])

  ami                    = local.ami_id
  instance_type          = local.instance_type
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]

  associate_public_ip_address = true

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

  attach_ebs_volumes = [
    {
      device_name = "/dev/xvdb",
      volume_id   = module.ebs_volume_a.ebs_volume_id
    },
    {
      device_name = "/dev/xvdc",
      volume_id   = module.ebs_volume_b.ebs_volume_id
    }
  ]

  tags = module.app_prod_bastion_label.tags
}
