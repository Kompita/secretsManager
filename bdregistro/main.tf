resource "random_password" "db_pass" {
  length           = 32
  special          = true
  numeric          = true
  override_special = "!#$%&*()_=+[]{}<>:?"
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier        = var.cluster_identifier
  engine                    = "aurora-postgresql"
  engine_version            = var.engine_version
  storage_encrypted         = true
  engine_mode               = "provisioned"
  master_username           = var.master_username
  master_password           = random_password.db_pass.result
  database_name             = var.dbname
  skip_final_snapshot       = false
  final_snapshot_identifier = var.final_snapshot_identifier
  deletion_protection       = true
  db_subnet_group_name      = var.db_subnet_group_name
  vpc_security_group_ids    = var.vpc_security_group_ids

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }
}

resource "aws_rds_cluster_instance" "example" {
  identifier         = var.cluster_instance_identifier
  cluster_identifier = aws_rds_cluster.rds_cluster.cluster_identifier
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
}
