module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 5.2"

  count = var.component_provisioning.rds ? 1 : 0
  depends_on = [
    aws_db_subnet_group.default_eks
  ]

  name                  = local.name
  engine                = "aurora-mysql"
  engine_mode           = "provisioned"
  engine_version        = var.rds_config.engine_version
  instance_type         = var.rds_config.instance_size
  instance_type_replica = var.rds_config.replica_size
  storage_encrypted     = true
  kms_key_id            = aws_kms_key.rds_encryption[0].arn

  vpc_id                = data.aws_vpc.cluster_vpc[0].id
  db_subnet_group_name  = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-data"
  subnets               = data.aws_subnet_ids.cluster_vpc_private_subnet_ids[0].ids
  create_security_group = true
  allowed_cidr_blocks   = [for s in data.aws_subnet.cluster_vpc_private_subnets : s.cidr_block]

  replica_count                       = var.rds_config.replica_count
  iam_database_authentication_enabled = true
  password                            = random_password.master[0].result
  create_random_password              = false

  apply_immediately   = var.environment == "prod" ? false : true
  skip_final_snapshot = var.environment == "prod" ? true : false

  db_parameter_group_name         = var.rds_config.default_parameter_group_name == "" ? aws_db_parameter_group.default_wordpress[0].id : var.rds_config.default_parameter_group_name
  db_cluster_parameter_group_name = var.rds_config.cluster_default_parameter_group_name == "" ? aws_rds_cluster_parameter_group.default_wordpress[0].id : var.rds_config.cluster_default_parameter_group_name
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  backtrack_window      = var.environment == "prod" ? 259200 : 43200
  copy_tags_to_snapshot = true
  deletion_protection   = var.environment == "prod" ? true : false

  database_name = var.rds_database_config.database_name != "" ? var.rds_database_config.database_name : "minimal"

  tags = local.tags
}

resource "aws_db_subnet_group" "default_eks" {
  count = var.component_provisioning.rds ? 1 : 0

  name       = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-data"
  subnet_ids = data.aws_subnet_ids.cluster_vpc_private_subnet_ids[0].ids

  tags = local.tags
}

resource "aws_db_parameter_group" "default_wordpress" {
  count = var.component_provisioning.rds && var.rds_config.default_parameter_group_name == "" ? 1 : 0

  name        = "${local.name}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-db-57-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "default_wordpress" {
  count = var.component_provisioning.rds && var.rds_config.default_parameter_group_name == "" ? 1 : 0

  name        = "${local.name}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-57-cluster-parameter-group"
  tags        = local.tags

  ## Ensuring that UTF8MB4 is the character set by default
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "binary"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  ## Supporting large blob files and reporting mechansims
  parameter {
    name  = "innodb_file_format"
    value = "Barracuda"
  }

  # Not applicable in Aurora RDS
  # parameter {
  #   name = "innodb_log_file_size"
  #   value = "40265318400"
  # }

  parameter {
    name  = "max_allowed_packet"
    value = "33554432"
  }
}

locals {
  name   = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-data"
  region = var.aws_region
  tags = {
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-data"
    Environment     = var.environment
    Product         = var.product
    Billingcustomer = var.billingcustomer
    Version         = data.local_file.terraform-module-version.content
  }
}

resource "random_password" "master" {
  count = var.component_provisioning.rds ? 1 : 0

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  upper            = true
  number           = true
}

resource "aws_kms_key" "rds_encryption" {
  count = var.component_provisioning.rds ? 1 : 0

  enable_key_rotation = true
  description         = "${var.namespace}-${var.app_slug}-${var.environment} RDS Secret Encryption Key"
  tags = {
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}-rds-key"
    Environment     = var.environment
    Billingcustomer = var.billingcustomer
    Namespace       = var.namespace
    Product         = var.product
    Version         = data.local_file.terraform-module-version.content
  }
}
