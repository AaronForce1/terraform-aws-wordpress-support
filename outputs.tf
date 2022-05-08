output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = var.component_provisioning.rds ? module.aurora[0].rds_cluster_endpoint : null
}

output "this_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = var.component_provisioning.rds ? module.aurora[0].rds_cluster_reader_endpoint : null
}

output "this_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = var.component_provisioning.rds ? module.aurora[0].rds_cluster_instance_endpoints : null
}

output "this_rds_cluster_instance_root_password" {
  description = "RDS Cluster Master Password"
  value       = var.component_provisioning.rds ? random_password.master[0].result : null
  sensitive   = true
}

output "this_s3_bucket_id" {
  description = "AWS S3 Bucket"
  value       = var.component_provisioning.s3 ? module.s3_website_bucket[0].this_s3_bucket_id : null
}
output "this_iam_user_access_key_id" {
  description = "Access Key ID for Provisioned IAM User for S3"
  value       = var.component_provisioning.s3 && var.s3_config.provision_user ? module.iam_user[0].this_iam_access_key_id : null
  sensitive   = true
}

output "this_iam_user_access_key_secret" {
  description = "Access Secret for Provisioned IAM User for S3"
  value       = var.component_provisioning.s3 && var.s3_config.provision_user ? module.iam_user[0].this_iam_access_key_secret : null
  sensitive   = true
}

output "this_iam_ro_user_access_key_id" {
  description = "Access Key ID for Provisioned IAM User for S3"
  value       = var.component_provisioning.s3 && var.s3_config.provision_user && var.environment == "production" ? module.iam_user_ro[0].this_iam_access_key_id : null
  sensitive   = true
}

output "this_iam_ro_user_access_key_secret" {
  description = "Access Secret for Provisioned IAM User for S3"
  value       = var.component_provisioning.s3 && var.s3_config.provision_user && var.environment == "production" ? module.iam_user_ro[0].this_iam_access_key_secret : null
  sensitive   = true
}

output "provisioned_efs_filesystems" {
  description = "AWS EFS IDs for all filesystems provisioned"

  value = module.efs-provisioning
}
