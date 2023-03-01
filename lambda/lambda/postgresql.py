## Lambda Postgresql 

## getCredentials() se conecta al SecretsManager para obtener las credenciales de la BD de registro 
## La funcion principal recibe como parametro el nombre del secreto rotado y el projecto asocidado
## se conecta a la BD de registro para obtener la url del repositorio de código y el path donde 
## se localiza el fichero secrets.yaml que contiene el secreto a rotar.

import os
import json
import boto3
import sys
import psycopg2

sys.path.append('./libs/psycopg2')

## Devuelve las credenciales de la DB de registro
def getCredentialsDB():
    print("Lambda Postgresql getGredentialsDB...")         
    credential = {}    
    secret_name_bd = "nombre_secreto_acceso_db"        
    client = boto3.client(
      service_name='secretsmanager',
      region_name=os.environ['AWS_REGION']
    )    
    get_secret_value_response = client.get_secret_value(
      SecretId=secret_name_bd
    )
    secret = json.loads(get_secret_value_response['SecretString'])    
    credential['username'] = secret['username']
    credential['password'] = secret['password']
    credential['host'] = "hostname_db"
    credential['db'] = "db"    
    return credential

## Se conecta a la BD de registro para devolver la url del repo
## y el fichero a modificar
def lambda_handler(event, context):
  print("Lambda Postgresql lambda_handler...") 
  
  print('event:', json.dumps(event))
  print('queryStringParameters:', json.dumps(event['queryStringParameters']))

  secret_name = event['queryStringParameters']['secret_name']
  proyect_name = event['queryStringParameters']['proyect_name']
  credential = getCredentialsDB()  
  try:     
    connection = psycopg2.connect(user=credential['username'], password=credential['password'], host=credential['host'], database=credential['db'])
    print("Successfully connected to the database...")
    cursor = connection.cursor()
    query = "select url, file from applications where secretName= %s",[secret_name], " and proyectName= %s",[proyect_name]
    cursor.execute(query)
    print("Fetching data from the database...")
    return { 'statusCode': 200, 'body': cursor.fetchone() } 
  except (Exception, psycopg2.Error) as error:
    print("Error while fetching data from database", error)
  finally:    
    if connection:
      cursor.close()
      connection.close()
      print("PostgreSQL connection is closed")

