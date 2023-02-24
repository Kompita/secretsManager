output "cluster_id" {
  value = aws_rds_cluster.rds_cluster.id
}

output "cluster_arn" {
  value = aws_rds_cluster.rds_cluster.arn
}

output "writer_endpoint" {
  value = aws_rds_cluster.rds_cluster.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.rds_cluster.reader_endpoint
}

output "master_username" {
  value     = aws_rds_cluster.rds_cluster.master_username
  sensitive = true
}

output "master_password" {
  value     = aws_rds_cluster.rds_cluster.master_password
  sensitive = true
}
