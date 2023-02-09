data "aws_caller_identity" "current" {} 

locals {
    aws_service_rol_config = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
    tags = {
        owner = "lara"
        app = "test-correos"
    }
}