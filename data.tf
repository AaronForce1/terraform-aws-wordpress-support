data "local_file" "terraform-module-version" {
  filename = "${path.module}/VERSION"
}

data "aws_vpc" "cluster_vpc" {
  count = var.component_provisioning.rds ? 1 : 0

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}*"]
  }
}

data "aws_subnet_ids" "cluster_vpc_private_subnet_ids" {
  count  = var.component_provisioning.rds ? 1 : 0
  vpc_id = data.aws_vpc.cluster_vpc[0].id

  tags = {
    Name = try("${var.subnet_name}*", "${var.vpc_name}*")
  }
}

data "aws_subnet" "cluster_vpc_private_subnets" {
  for_each = try(data.aws_subnet_ids.cluster_vpc_private_subnet_ids[0].ids, toset([]))
  id       = each.value
}