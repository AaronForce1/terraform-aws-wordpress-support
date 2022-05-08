locals {
  module_version = chomp(data.local_file.terraform-module-version.content)
}

locals {
  kubernetes_tags = {
    Name                                                                            = "${var.app_slug}-${var.namespace}-${var.environment}"
    Environment                                                                     = var.environment
    billingcustomer                                                                 = var.billingcustomer
    Namespace                                                                       = var.namespace
    Product                                                                         = var.app_slug
    Version                                                                         = local.module_version
    infrastructure-terraform-eks                                                    = local.module_version
    "k8s.io/cluster-autoscaler/enabled"                                             = true
    "k8s.io/cluster-autoscaler/${var.app_slug}-${var.namespace}-${var.environment}" = true
  }
  additional_kubernetes_tags = {
    Name                         = "${var.app_slug}-${var.namespace}-${var.environment}"
    Environment                  = var.environment
    billingcustomer              = var.billingcustomer
    Namespace                    = var.namespace
    Product                      = var.app_slug
    infrastructure-terraform-eks = local.module_version
  }
}

locals {
  # map aws_region to friendlier naming
  aws_region = lookup(
    {
      "us-east-2"      = "ohio",
      "us-east-1"      = "nvirginia",
      "us-west-1"      = "ncalifornia",
      "us-west-2"      = "oregon",
      "af-south-1"     = "capetown",
      "ap-east-1"      = "hongkong",
      "ap-south-1"     = "mumbai",
      "ap-northeast-3" = "osaka",
      "ap-northeast-2" = "seoul",
      "ap-southeast-1" = "singapore",
      "ap-southeast-2" = "sydney",
      "ap-northeast-1" = "tokyo",
      "ca-central-1"   = "central",
      "cn-north-1"     = "beijing",
      "cn-northwest-1" = "ningxia",
      "eu-central-1"   = "frankfurt",
      "eu-west-1"      = "ireland",
      "eu-west-2"      = "london",
      "eu-south-1"     = "milan",
      "eu-west-3"      = "paris",
      "eu-north-1"     = "stockholm",
      "me-south-1"     = "bahrain",
      "sa-east-1"      = "saopaulo",
      "us-gov-east-1"  = "useast",
      "us-gov-west-1"  = "uswest"
    },
  var.aws_region, var.aws_region)
}


