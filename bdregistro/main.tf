resource "random_password" "db_pass" {
  count   = var.master_password == "" ? 1 : 0
  length  = 32
  special = true
  number  = true
  override_special = "!#$%&*()_=+[]{}<>:?"
}

resource "aws_rds_cluster" "this" {
  cluster_identifier                    = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-dbcluster-01"
  engine                                = "aurora-postgresql"
  engine_version                        = var.engine_version
  storage_encrypted                     = true
  engine_mode                           = "provisioned"
  master_username                       = var.master_username
  master_password                       = local.master_password
  skip_final_snapshot                   = false
  final_snapshot_identifier             = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-snapshot-01"
  deletion_protection                   = true
  db_subnet_group_name                  = local.db_subnet_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  # port                                  = 5444: Aurora Serverless currently doesn't support using a custom database port.
  backup_retention_period               = 7
  preferred_backup_window               = "23:30-00:30"

  # 'scaling_configuration' is only valid when engine_mode is set to serverless.
  serverlessv2_scaling_configuration {
    # These capacities are not instances they are Aurora capacity units (ACUs). Have a look at:
    # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.how-it-works.html
    min_capacity             = 0.5
    max_capacity             = 2
  }

  tags = merge(
    local.tags,
    {
      Name = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-dbcluster-01"
      "correos:nombre" = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-dbcluster-01"
    }
  )
}

resource "aws_rds_cluster_instance" "example" {
  identifier         = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-instance-01"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  tags               = merge(
    local.tags,
    {
      Name = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-instance-01"
      "correos:nombre" = "aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-instance-01"
    }
  )
}
