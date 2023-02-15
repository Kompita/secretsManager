locals {
  master_password      = var.master_password == "" ? random_password.db_pass[0].result : var.master_password
  instance_class       = var.prod ? "db.r5.large" : "db.t3.medium"
  db_subnet_group_name = var.db_subnet_group_name == "" ? "aw${var.aws_region_id}-${var.environment}-d0-subnet-group-02" : var.db_subnet_group_name
  # Inspired from: https://www.reddit.com/r/Terraform/comments/am4d81/conditionally_add_keyvalue_to_map_or_not_at_all/
  optional_tag = {
    prod = {}
    not_prod = {
      StartStopid = "OCPDES"
    }
  }
  tags = merge(
    var.tags,
    local.optional_tag[var.prod? "prod" : "not_prod"]
  )
}
