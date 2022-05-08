# terraform-aws-wordpress-support

[![LICENSE](https://img.shields.io/badge/license-Apache_2-blue)](https://opensource.org/licenses/Apache-2.0)

A custom-built terraform module, leveraging terraform's aws provider to spawn supplemental infrastructure that supports Wordpress environments. This includes:
- AWS S3 Buckets used for uploads and static media files
- AWS IAM Roles for these S3 Buckets
- AWS RDS Aurora MySQL/Postgres databases
- AWS EFS drives

## Usage
_(TBC) - in the meantime, feel free to have a look at `examples/full-wordpress`_

## Contributing
Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally, which is required as a git pre-commit hook.

## Authors

Created by [Aaron Baideme](https://gitlab.com/aaronforce1) - aaron.baideme@advancedtechnologies.com.hk

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.48.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | ~> 5.2 |
| <a name="module_efs-provisioning"></a> [efs-provisioning](#module\_efs-provisioning) | ./submodules/efs | n/a |
| <a name="module_iam_user"></a> [iam\_user](#module\_iam\_user) | terraform-aws-modules/iam/aws//modules/iam-user | ~> 3.0 |
| <a name="module_iam_user_ro"></a> [iam\_user\_ro](#module\_iam\_user\_ro) | terraform-aws-modules/iam/aws//modules/iam-user | ~> 3.0 |
| <a name="module_s3_website_bucket"></a> [s3\_website\_bucket](#module\_s3\_website\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 1.22 |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.default_wordpress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.default_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.s3_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_access_policy_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.s3_attach_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_attach_roles_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.s3_attach_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.s3_attach_user_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster_parameter_group.default_wordpress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [random_password.master](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy_document.policy_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_data_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.cluster_vpc_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet_ids.cluster_vpc_private_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.cluster_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [local_file.terraform-module-version](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_origin_urls"></a> [allowed\_origin\_urls](#input\_allowed\_origin\_urls) | A list of specific FE urls that should be allowed via CORS to access resources in S3 | `list(string)` | `[]` | no |
| <a name="input_app_slug"></a> [app\_slug](#input\_app\_slug) | Application Slug | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region for the VPC | `any` | n/a | yes |
| <a name="input_billingcustomer"></a> [billingcustomer](#input\_billingcustomer) | Which BILLINGCUSTOMER is setup in AWS | `any` | n/a | yes |
| <a name="input_component_provisioning"></a> [component\_provisioning](#input\_component\_provisioning) | Component Provisioning for this Wordpress environment: S3, RDS, EFS Filesystem Name(s)? | <pre>object({<br>    s3              = bool<br>    rds             = bool<br>    efs_filesystems = list(string)<br>  })</pre> | <pre>{<br>  "efs_filesystems": [],<br>  "rds": true,<br>  "s3": false<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `any` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Application Namespace used for this infrastructure | `any` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Specific product/application used for this terraform provisioning | `string` | `"wordpress-website"` | no |
| <a name="input_rds_config"></a> [rds\_config](#input\_rds\_config) | RDS Configuration Parameters | <pre>object({<br>    instance_size                        = string<br>    replica_size                         = string<br>    replica_count                        = number<br>    default_parameter_group_name         = string<br>    cluster_default_parameter_group_name = string<br>    engine_version                       = string<br>  })</pre> | <pre>{<br>  "cluster_default_parameter_group_name": "default-aurora-db-57-parameter-group",<br>  "default_parameter_group_name": "default-aurora-db-57-parameter-group",<br>  "engine_version": "5.7.mysql_aurora.2.09.2",<br>  "instance_size": "db.r6g.large",<br>  "replica_count": 0,<br>  "replica_size": "db.t3.medium"<br>}</pre> | no |
| <a name="input_rds_database_config"></a> [rds\_database\_config](#input\_rds\_database\_config) | Provision initial database and user credentials | <pre>object({<br>    database_name     = string<br>    database_user     = string<br>    database_password = string<br><br>  })</pre> | <pre>{<br>  "database_name": "",<br>  "database_password": "",<br>  "database_user": "wordpress-user"<br>}</pre> | no |
| <a name="input_s3_config"></a> [s3\_config](#input\_s3\_config) | S3 Configuration Parameters | <pre>object({<br>    provision_user      = bool<br>    provision_iam_roles = list(string)<br>  })</pre> | <pre>{<br>  "provision_iam_roles": [],<br>  "provision_user": true<br>}</pre> | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Full Subnet name or prefix of name, required for the system to find the necessary subnets to configure any additional networking components, if left null, it will try to search via VPC Name | `any` | `null` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Full VPC name or prefix of name, required for the system to find the VPC to configure any additional networking components | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provisioned_efs_filesystems"></a> [provisioned\_efs\_filesystems](#output\_provisioned\_efs\_filesystems) | AWS EFS IDs for all filesystems provisioned |
| <a name="output_this_iam_ro_user_access_key_id"></a> [this\_iam\_ro\_user\_access\_key\_id](#output\_this\_iam\_ro\_user\_access\_key\_id) | Access Key ID for Provisioned IAM User for S3 |
| <a name="output_this_iam_ro_user_access_key_secret"></a> [this\_iam\_ro\_user\_access\_key\_secret](#output\_this\_iam\_ro\_user\_access\_key\_secret) | Access Secret for Provisioned IAM User for S3 |
| <a name="output_this_iam_user_access_key_id"></a> [this\_iam\_user\_access\_key\_id](#output\_this\_iam\_user\_access\_key\_id) | Access Key ID for Provisioned IAM User for S3 |
| <a name="output_this_iam_user_access_key_secret"></a> [this\_iam\_user\_access\_key\_secret](#output\_this\_iam\_user\_access\_key\_secret) | Access Secret for Provisioned IAM User for S3 |
| <a name="output_this_rds_cluster_endpoint"></a> [this\_rds\_cluster\_endpoint](#output\_this\_rds\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_this_rds_cluster_instance_endpoints"></a> [this\_rds\_cluster\_instance\_endpoints](#output\_this\_rds\_cluster\_instance\_endpoints) | A list of all cluster instance endpoints |
| <a name="output_this_rds_cluster_instance_root_password"></a> [this\_rds\_cluster\_instance\_root\_password](#output\_this\_rds\_cluster\_instance\_root\_password) | RDS Cluster Master Password |
| <a name="output_this_rds_cluster_reader_endpoint"></a> [this\_rds\_cluster\_reader\_endpoint](#output\_this\_rds\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_this_s3_bucket_id"></a> [this\_s3\_bucket\_id](#output\_this\_s3\_bucket\_id) | AWS S3 Bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


