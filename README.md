# **Indice**

[1. **Descripción**](#1-descripcion)

&nbsp;&nbsp;[1.1. Requisitos](#1.1-requisitos)

[2. **Módulos**](#2-modulos)

&nbsp;&nbsp;[2.1. AWS Step Functions](#2.1-aws-step-functions)

&nbsp;&nbsp;&nbsp;[2.1.1 Descripción](#2.1.1-descripción)

&nbsp;&nbsp;&nbsp;[2.1.2 Uso](#2.1.2-uso)

&nbsp;&nbsp;[2.2. AWS Config](#2.2-aws-config)

&nbsp;&nbsp;&nbsp;[2.2.1 Descripción](#2.2.1-descripción)

&nbsp;&nbsp;&nbsp;[2.2.2 Uso](#2.2.2-uso)

&nbsp;&nbsp;[2.3. AWS Aurora Serverless v2](#2.3-aws-aurora-serverless-v2)

&nbsp;&nbsp;&nbsp;[2.3.1 Descripción](#2.3.1-descripción)

&nbsp;&nbsp;&nbsp;[2.3.2 Uso](#2.3.2-uso)

# 1. **Descripción**

> Este repositorio contiene una carpeta por cada uno de los módulos de Terraform necesarios para poder implementar
> el Planteamiento 1 de la inciativa de Secrets Manager.

## 1.1. **Requisitos**

| Nombre      | Version  |
|-------------|----------|
| aws         | 0.1.0    |
| terraform   | 0.1.0    |

# 2. **Módulos**

A continuación se describen los módulos de terraform incluidos en este repositorio:

## 2.1. **AWS Step Functions**

### 2.1.1 **Descripción**

### 2.1.2 **Uso**

## 2.2. **AWS Config**

### 2.2.1 **Descripción**

Módulo para el despliegue de AWS Config.

Utiliza las AWS Config Rules que representan la configuración deseada para un conjunto de recursos para toda una cuenta de AWS. Al añadir una regla, AWS compara los recursos con la condiciones impuestas. Después de esta evaluación inicial, las reglas se pueden lanzar de manera periódica, o cada vez que cambia un recurso.

Este servico utilizará las reglas por defecto que implementa AWS para el servicio Secrets Manager.

| Nombre | Descripción | Parámetros |  |  |
|---|---|---|---|---|
| secretsmanager-rotation-enabled-check | Comprueba que la rotación está configurada para los secretos almacenados.<br>La regla es NON_COMPILANT si el secreto no está programado para la rotación o la frecuencia de rotado es mas alta que la especificada en el parametro maximumAllowedRotationFrequency | - maximumAllowedRotationFrequency (opcional): Frecuencia máxima de rotado del secreto en dias<br>- maximumAllowedRotationFrequencyInHours (opcional): Frecuencia maxima del rotado en horas |  |  |
| secretsmanager-scheduled-rotation-success-check | Comprueba si la última rotación ha funcionado dentro de los parámetros de rotación configurados              | NA |  |  |
| secretsmanager-secret-periodic-rotation | Comprueba si los secretos han rotado dentro del número de dias especificado.<br>La regla es NON_COMPILANT si el secreto no ha rotado en el periodo establecido por maxDaysSinceRotation, que es de  90 días por defecto.  | - maxDaysSinceRotation (opcional): Número máximo de días dentro de los cuales el secreto ha rotado. El valor por defecto es 90.  |  |  |
| secretsmanager-secret-unused | Comprueba si los secretos han sido accedidos en un número especificado de días.<br>La regla es NON_COMPILANT si el secreto no ha sido accedido durante el periodo de días establecido por el parámetro unusedForDays, que es de 90 dias por defecto.  | - unusedForDays (opcional): Número de días en los que un secreto puede no haber sido accedido. El valor por defecto es de 90 días. |  |  |
| secretsmanager-using-cmk | Comprueba si los secretos están encriptados usando la clave aws/secretsmanager o una clave propia creada en AWS KMS.<br>La regla es NON_COMPILANT si el secreto ha sido encriptado usando la clave aws/secretsmanager | - kmsKeyArns (opcional): Lista de ARNs de claves KMS separada por comas (CSV) para comprobar que se utilizan en el cifrado.  |  |  |

### 2.2.2 **Uso**

## 2.3. **AWS Aurora Serverless v2**

### 2.3.1 **Descripción**

Módulo para el despliegue de una base de datos Aurora con motor PostgreSQL en configuración "serverless" (<https://aws.amazon.com/rds/aurora/serverless/>), para alojar la tabla de relaciones que permita relacionar cada secreto con los repositorios GIT afectados por la rotación del mismo.

Crea un clúster de tipo provisioned ... TODO

    - explicar por qué no se usa un cluster serverless
      - cluster serverless no puede contener instancias provisioned (COMPROBAR)
        - con cluster provisioned se pueden usar tanto instancias provisioned como serverless
      - si se empieza con cluster serverless, no se puede volver a uno provisioned
        - con un cluster provisioned, se puede hacer el cambio a serverless

Versión minima de Aurora postgresql 13.6 ... TODO

#### Recursos

Este módulo crea los siguientes recursos:

Recurso | Tipo de Recurso
 --- | ---
`aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-dbcluster-01` | Clúster Aurora PostgreSQL
`aw${var.aws_region_id}-${var.environment}-${var.dbname}-rds-instance-01` | Instancia Aurora PostgreSQL Serverless

#### Parámetros de Entrada

Variable | Tipo | Descripción | Valor por Defecto | Requerido | Ejemplo
 --- | --- | --- | --- | --- | ---
engine_version | string | Versión Aurora PostgreSQL | `13.6` | no | `13.6`
master_username | string | Nombre del Usuario Maestro de la BD | `system_aws` | no | `admin`
master_password | string | Contraseña del Usuario Maestro de la BD, si no se provee se generará una aleatoria | `` | no | `p4Ss#123456`
environment | string | Identificador del Entorno siguiendo el estándar de nomenclatura de Correos | | sí | `d`
aws_region_id | string | Identificador del la Región AWS siguiendo el estándar de nomenclatura de Correos | | sí | `ir`
prod | bool | True si es un entorno de producción | `false` | no | `true`
dbname | string | Identificador de la BD | | sí | `myApp`
db_subnet_group_name | string | DBSubnetGroup donde se creará el clúster | `aw${var.aws_region_id}-${var.environment}-d0-subnet-group-01` | no | `awir-d-d0-subnet-group-01`
vpc_security_group_ids | list(string) | Lista de los 'security groups' que se enlazarán al nuevo clúster | | sí | `["sg-0123456"]`
tags | map(string) | Map con todos los tags a aplicar a los recursos | `{}` | no | `{ "Client" = "ClientName", "Environment" = "Test" }`

#### Parámetros de Salida

Variable | Tipo | Descripción | Ejemplo
 --- | --- | --- | ---
cluster_id | string | Id del Clúster Aurora | `awir-d-myApp-rds-dbcluster-01`
cluster_arn | string | ARN del Clúster Aurora | `arn:aws:rds:eu-west-1:123456789012:cluster:awir-d-myApp-rds-dbcluster-01`
writer_endpoint | string | Endpoint del Clúster Aurora  | `awir-d-myApp-rds-dbcluster-01.cluster-123456789012.eu-west-1.rds.amazonaws.com:5444`
reader_endpoint | string | Endpoint de solo lectura  del Clúster Aurora |
master_username | string | Nombre del Usuario Maestro de la BD | `admin`
master_password | string | Contraseña del Usuario Maestro de la BD | `p4Ss#123456`

### 2.3.2 **Uso**

```terraform
provider "aws" {}

module "db" {
  source                 = "git::https://ic.correos.es/git/arquitectura/ModulosTerraform/aws-rds-aurora-serverless-postgresql.git?ref=master"
  prod                   = false
  environment            = "d"
  aws_region_id          = "ir"
  dbname                 = "myApp"
  vpc_security_group_ids = ["sg-1234567"]
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
}
```
