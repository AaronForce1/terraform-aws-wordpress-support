resource "aws_efs_file_system" "efs_filesystems" {
  count          = length(var.names)
  creation_token = trimsuffix(substr("${var.namespace}-${var.app_slug}-${var.environment}-efs-${var.names[count.index]}", 0, 63), "-")

  tags = {
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}-efs-${var.names[count.index]}"
    Environment     = var.environment
    Terraform       = true
    Namespace       = var.namespace
    Product         = var.product
    Billingcustomer = var.billingcustomer
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  encrypted  = true
  kms_key_id = aws_kms_key.efs_encryption[0].arn
}

resource "aws_kms_key" "efs_encryption" {
  count = length(var.names) > 0 ? 1 : 0

  enable_key_rotation = true
  description         = "${var.namespace}-${var.app_slug}-${var.environment} EFS Secret Encryption Key"
  tags = {
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}-efs-key"
    Environment     = var.environment
    Billingcustomer = var.billingcustomer
    Namespace       = var.namespace
    Product         = var.product
    Version         = data.local_file.terraform-module-version.content
  }
}