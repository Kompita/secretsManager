variable "tags" {
  type = map(string)
  default = {}
  description = "tags for resources"
}

variable "target_arn" {
  type = string
  description = "target arn"
}