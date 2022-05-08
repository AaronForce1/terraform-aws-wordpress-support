data "local_file" "terraform-module-version" {
  filename = "${path.module}/VERSION"
}