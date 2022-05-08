output "provisioned_efs_filesystems" {
  description = "AWS EFS'"
  value       = aws_efs_file_system.efs_filesystems
}