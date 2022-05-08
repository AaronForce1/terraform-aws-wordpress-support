##TODO: Migrate IAM USER to IAM ROLE

### IAM USER DEFINITION
module "iam_user_ro" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 3.0"
  count   = var.component_provisioning.s3 && var.s3_config.provision_user && var.environment == "production" ? 1 : 0

  name = trimsuffix(substr("${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-ro-user", 0, 63), "-")
  path = "/serviceaccounts/${var.namespace}/${var.environment}/"

  create_iam_access_key         = true
  create_iam_user_login_profile = false


  force_destroy = var.environment == "production" ? true : false

  ## TODO: Setup PGP Encryption for Access KEY/SECRET provisioning
  # pgp_key = "keybase:test"

  password_reset_required = false

  tags = {
    description     = "Terraform Generated : ${var.namespace}-${var.app_slug}-${var.environment}"
    Name            = "${var.namespace}-${var.app_slug}-${var.environment}"
    Environment     = var.environment
    Product         = var.product
    Billingcustomer = var.billingcustomer
    Version         = data.local_file.terraform-module-version.content
  }
}

### IAM POLICY DEFINITION
resource "aws_iam_policy" "s3_access_policy_ro" {
  count = var.component_provisioning.s3 && var.environment == "production" ? 1 : 0

  name        = "${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-web-files-readonly-policy"
  description = "Terraform Generated : ${var.namespace}-${var.app_slug}-${var.environment}"

  path   = "/serviceaccounts/${var.namespace}/${var.environment}/"
  policy = data.aws_iam_policy_document.policy_data_ro.json
}

data "aws_iam_policy_document" "policy_data_ro" {
  statement {
    sid = "1"
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:GetObjectAcl",
      "s3:GetObjectVersionAcl",
      "s3:GetBucketWebsite",
      "s3:GetBucketNotification",
      "s3:GetReplicationConfiguration",
      "s3:ListMultipartUploadParts",
      "s3:GetObject",
      "s3:GetAnalyticsConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetLifecycleConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetBucketTagging",
      "s3:GetBucketLogging",
      "s3:ListBucketVersions",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetObjectVersionTorrent",
      "s3:GetBucketRequestPayment",
      "s3:GetObjectTagging",
      "s3:GetMetricsConfiguration",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketVersioning",
      "s3:GetBucketAcl",
      "s3:GetObjectTorrent",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:ListBucketByTags",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${trimsuffix(substr("${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-web-files", 0, 62), "-")}/*",
      "arn:aws:s3:::${trimsuffix(substr("${var.namespace}-${var.app_slug}-${var.environment}-${local.aws_region}-web-files", 0, 62), "-")}"
    ]
  }
}

## IAM POLICY ATTACHMENT
resource "aws_iam_user_policy_attachment" "s3_attach_user_ro" {
  count = var.component_provisioning.s3 && var.s3_config.provision_user && var.environment == "production" ? 1 : 0

  user       = module.iam_user_ro[0].this_iam_user_name
  policy_arn = aws_iam_policy.s3_access_policy_ro[0].arn
}

resource "aws_iam_role_policy_attachment" "s3_attach_roles_ro" {
  count = var.component_provisioning.s3 && var.environment == "production" && length(var.s3_config.provision_iam_roles) > 0 ? length(var.s3_config.provision_iam_roles) : 0

  role       = var.s3_config.provision_iam_roles[count.index]
  policy_arn = aws_iam_policy.s3_access_policy_ro[0].arn
}