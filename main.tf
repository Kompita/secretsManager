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