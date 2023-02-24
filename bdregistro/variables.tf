variable "cluster_identifier" {
  type        = string
  description = "Name to identify the cluster"
}

variable "engine_version" {
  type        = string
  default     = "13.6"
  description = "Engine Version to be used"
}

variable "master_username" {
  type        = string
  default     = "system_aws"
  description = "Master Username to be used"
}

variable "dbname" {
  type        = string
  description = "Name for an automatically created database on cluster creation"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final DB snapshot when this DB cluster is deleted"
}

variable "db_subnet_group_name" {
  type        = string
  description = "A DB subnet group to associate with this DB instance"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of VPC security groups to associate with the Cluster"
}

variable "cluster_instance_identifier" {
  type        = string
  description = "Name to identify the cluster instance"
}
