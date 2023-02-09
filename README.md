# **Indice**
[1. **Descripción**](#1-descripcion)

&nbsp;&nbsp;[1.1. Requisitos](#1.1-requisitos)

[2. **Módulos**](#2-modulos)

&nbsp;&nbsp;[2.1. AWS Step Functions](#2.1-aws-step-functions)

&nbsp;&nbsp;&nbsp;[2.1.1 Descripción](#2.1.1-descripción)

&nbsp;&nbsp;&nbsp;[2.1.2 Uso](#2.1.2-uso)

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
## 2.1.1 **Descripción**
## 2.1.2 **Uso**
## 2.2. **AWS Config**
## 2.2.1 **Descripción**
Módulo para el despliegue de AWS Config. 

Este servico utilizará las reglas por defecto que implementa AWS para el servicio Secrets Manager. 

| Nombre                                          | Descripción                                                                                                         |
|-------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| secretsmanager-rotation-enabled-check           | Comprueba que la rotación está configurada para los secretos almacenados                                            | 
| secretsmanager-scheduled-rotation-success-check | Comprueba si la última rotación ha funcionado dentro de los parámetros de rotación configurados                     |
| secretsmanager-secret-periodic-rotation         | Comprueba si los secretos han rotado dentro del número de dias especificado                                         | 
| secretsmanager-secret-unused                    | Comprueba si los secretos han sido accedidos en un número especificado de días                                      |
| secretsmanager-using-cmk                        | Comprueba si los secretos están encriptados usando la clave aws/secretsmanager o una clave propia creada en AWS KMS |

En el módulo se utiliza el rol que utiliza AWS por defecto AWSServiceRoleForConfig que le proporciona acceso a todos los elementos que integra por defecto AWS Config. En caso de ser necesario se puede crear un rol que solo permita el acceso a los elementos requeridos
## 2.2.2 **Uso**