module "s3_website_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.22"
  count   = var.component_provisioning.s3 ? 1 : 0

  bucket = trimsuffix(substr("${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-web-files", 0, 62), "-")

  acl           = "public-read"
  force_destroy = var.environment == "prod" ? true : false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }

  cors_rule = [
    {
      allowed_methods = ["GET"]
      allowed_origins = var.allowed_origin_urls
      allowed_headers = ["Authorization"]
      expose_headers  = [""]
      max_age_seconds = 3000
    }
  ]

  tags = {
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-web-files"
    Environment     = var.environment
    Namespace       = "${var.namespace}-${var.app_slug}"
    Product         = var.product
    Billingcustomer = var.billingcustomer
    Version         = data.local_file.terraform-module-version.content
  }
}