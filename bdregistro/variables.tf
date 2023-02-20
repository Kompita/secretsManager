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

variable "master_password" {
  type        = string
  default     = ""
  description = "Master Password to be used"
}

variable "environment" {
  type = string
  description = "Environment identifier as Correos standard naming"
}

variable "aws_region_id" {
  type = string
  description = "aws region identifier as Correos standard naming"
}

variable "prod" {
  type = bool
  default = false
  description = "production environment"
}

variable "dbname" {
  type = string
}

# variable "db_subnet_group_name" {
#   type = string
#   default = ""
# }
# 
# variable "vpc_security_group_ids" {
#   type = list(string)
# }

variable "tags" {
  type = map(string)
  default = {}
}
