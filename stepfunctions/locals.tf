data "aws_caller_identity" "current" {} 
locals {
    account_id = data.aws_caller_identity.current.account_id   
    aws_service_rol_config = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
    tags = {
        owner = "vruizrob"
        app = "step-functions-correos"
    }
}

