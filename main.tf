terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
  profile = var.execution_profile
}

/*
module "awsconfig" {
  source = "./awsconfig"
  tags = local.tags
}*/


module "eventbridge" {
  source = "./eventbridge"
  tags = local.tags
  target_arn = "arn:aws:lambda:eu-west-1:936716798377:function:test-lara-event-from-eventbridge"
}


/*
module "bd" {
  source = "./bdregistro"
  prod                   = false
  environment            = "d"
  aws_region_id          = "ir"
  dbname                 = "myApp"
  tags                   = {
    Organizacion        = "myOrg"
    Proyecto            = "myProj"
    Entorno             = "Devel"
    Criticidad          = "Criticidad"
    Uso                 = "Uso"
    Departamento        = "Departamento"
    ClienteDeNegocio    = "ClienteDeNegocio"
    AreaResponsableDOTI = "AreaResponsableDOTI"
  }  
}*/

/*
resource "aws_serverlessapplicationrepository_cloudformation_stack" "postgres-rotator" {
  name           = "postgres-rotator"
  application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSPostgreSQLRotationSingleUser"
  capabilities = [
    "CAPABILITY_IAM",
    "CAPABILITY_RESOURCE_POLICY",
  ]
  parameters = {
    functionName = var.function_name
    endpoint     = "secretsmanager.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}"
  }
}

data "aws_partition" "current" {}
data "aws_region" "current" {}
*/