module "efs-provisioning" {
  source = "./submodules/efs"

  names           = var.component_provisioning.efs_filesystems
  app_slug        = var.app_slug
  namespace       = var.namespace
  environment     = var.environment
  billingcustomer = var.billingcustomer
  product         = var.product
}