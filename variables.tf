## GLOBAL VALUES
variable "aws_region" {
  description = "Region for the VPC"
}

variable "app_slug" {
  description = "Application Slug"
}

variable "namespace" {
  description = "Application Namespace used for this infrastructure"

  ## EXAMPLES
  # web-marketing
  # technology-system
}

variable "environment" {
  description = "Environment"

  ## EXAMPLES
  # prod
  # stag
  # test
  # uat
  # qa
}

variable "allowed_origin_urls" {
  description = "A list of specific FE urls that should be allowed via CORS to access resources in S3"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "Full VPC name or prefix of name, required for the system to find the VPC to configure any additional networking components"
}

variable "subnet_name" {
  description = "Full Subnet name or prefix of name, required for the system to find the necessary subnets to configure any additional networking components, if left null, it will try to search via VPC Name"
  default     = null
}

variable "billingcustomer" {
  description = "Which BILLINGCUSTOMER is setup in AWS"
}

variable "product" {
  description = "Specific product/application used for this terraform provisioning"
  default     = "wordpress-website"
}

variable "rds_config" {
  description = "RDS Configuration Parameters"
  type = object({
    instance_size                        = string
    replica_size                         = string
    replica_count                        = number
    default_parameter_group_name         = string
    cluster_default_parameter_group_name = string
    engine_version                       = string
  })
  default = {
    default_parameter_group_name         = "default-aurora-db-57-parameter-group"
    cluster_default_parameter_group_name = "default-aurora-db-57-parameter-group"
    instance_size                        = "db.r6g.large"
    replica_count                        = 0
    replica_size                         = "db.t3.medium"
    engine_version                       = "5.7.mysql_aurora.2.09.2"
  }
}

variable "rds_database_config" {
  description = "Provision initial database and user credentials"
  type = object({
    database_name     = string
    database_user     = string
    database_password = string

  })
  # sensitive = true
  default = {
    database_name     = ""
    database_user     = "wordpress-user"
    database_password = ""
  }
}

variable "s3_config" {
  description = "S3 Configuration Parameters"
  type = object({
    provision_user      = bool
    provision_iam_roles = list(string)
  })
  default = {
    provision_user      = true
    provision_iam_roles = []
  }
}

variable "component_provisioning" {
  description = "Component Provisioning for this Wordpress environment: S3, RDS, EFS Filesystem Name(s)?"
  type = object({
    s3              = bool
    rds             = bool
    efs_filesystems = list(string)
  })
  default = {
    s3              = false
    rds             = true
    efs_filesystems = []
  }
}