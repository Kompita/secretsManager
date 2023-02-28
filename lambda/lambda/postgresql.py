## Lambda Postgresql 
## getCredentials() se conecta al SecretsManager para obtener las credenciales de la BD de registro (cuando se cree la
## BD de registro se debe dar de alta en Secrets Manager los datos de conexion)
## La funcion principal recibce como parametro el secreto rotado y se conecta a la BD de registro para obtener la 
## url del repositorio de código y el path donde albergar el fichero secrets.yaml. 
## Estos datos deben ser devueltos a la Lambda de Git.

import json
import boto3
import sys
import logging
import psycopg2

sys.path.append('./libs/psycopg2')

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def getCredentials(event, context):
    logger.info(f'Lambda Postgresql getGredentials:')  
    print('event:', json.dumps(event))
    print('queryStringParameters:', json.dumps(event['queryStringParameters'])) 
    
    credential = {}    
    secret_name = "mysecretname"
    region_name = "eu-west-1"
    
    client = boto3.client(
      service_name='secretsmanager',
      region_name=region_name
    )
    
    get_secret_value_response = client.get_secret_value(
      SecretId=secret_name
    )
    
    secret = json.loads(get_secret_value_response['SecretString'])    
    credential['username'] = secret['username']
    credential['password'] = secret['password']
    credential['host'] = "aurora_postgre.eu-west-1.rds.amazonaws.com"
    credential['db'] = "databasename"    
    return credential

def lambda_handler(event, context):
  logger.info(f'Lambda Postgresql: {event}') 

  credential = getCredentials(event, context)
  connection = psycopg2.connect(user=credential['username'], password=credential['password'], host=credential['host'], database=credential['db'])
  cursor = connection.cursor()
  query = "select urlRepo from app"
  cursor.execute(query)
  results = cursor.fetchone()
  cursor.close()
  connection.commit()
  return results

