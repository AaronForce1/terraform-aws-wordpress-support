provider "aws" {
  region = "ap-east-1"
}

module "terraform-aws-wordpress" {
  source = "../../"

  aws_region = "ap-east-1"
  component_provisioning = {
    s3              = false
    rds             = false
    efs_filesystems = ["uploads", "translations"]
  }

  app_slug  = "marketing-website"
  namespace = "company"
  environment     = "develop"

  allowed_origin_urls = ["example.com"]
  vpc_name        = "default"

  rds_config = {
    default_parameter_group_name         = "default-aurora-db-57-parameter-group"
    cluster_default_parameter_group_name = "default-aurora-db-57-parameter-group"
    instance_size                        = "db.r6g.large"
    replica_count                        = 0
    replica_size                         = "db.t3.small"
    engine_version                       = "5.7.mysql_aurora.2.09.2"
  }

  rds_database_config = {
    database_name     = "wordpress"
    database_user     = "wordpress"
    database_password = ""
  }

  billingcustomer = "company"
  product         = "marketing-website"
}