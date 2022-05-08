variable "names" {
  description = "List of names for efs' entities to be created; for every name, a single EFS will be created"
  type        = list(string)
  default     = []
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

variable "billingcustomer" {
  description = "Which BILLINGCUSTOMER is setup in AWS"
}

variable "product" {
  description = "Specific product/application used for this terraform provisioning"
  default     = "wordpress-website"
}