variable "secret_id"{
    type = string
    description = "secret name or arn"
}

variable "secret_value" {
  default = {
    engine = "postgres"
    host = "host"
    username = "username"
    password = "password"
    dbname = "dbname"
    port = "port"
  }
  type = map(string)
}