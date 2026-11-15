locals {
  env  = "dev"
  name = "${var.project}-${local.env}"
}

module "network" {
  source = "../../modules/network"

  name               = local.name
  cidr_block         = var.vpc_cidr
  az_count           = var.az_count
  enable_nat_gateway = var.enable_nat_gateway
}

module "app_bucket" {
  source = "../../modules/s3_bucket"

  name          = "${local.name}-app"
  versioning    = true
  force_destroy = var.bucket_force_destroy
}

module "web" {
  source = "../../modules/ec2_instance"

  name               = "${local.name}-web"
  subnet_id          = module.network.public_subnet_ids[0]
  instance_type      = var.instance_type
  allowed_http_cidrs = var.allowed_http_cidrs
  instance_running   = var.instance_running

  bucket_name = module.app_bucket.bucket_name
  bucket_arn  = module.app_bucket.bucket_arn
}
