import os
import json
import boto3
import logging
import psycopg2 as pg2
from boto3.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

## Solicita a Secrets Manager el secreto para conectar a la BD de Resgistro
## Devuelve un objeto que contiene el valor del secreto
def getCredentialsSM(secret_name):
    logger.info(f'getGredentialsSM:')  
    try:            
      client = boto3.client(
        service_name='secretsmanager',
        region_name=os.environ['AWS_REGION']
      )       
      get_secret_value_response = client.get_secret_value(
        SecretId=secret_name
      )
      return json.loads(get_secret_value_response['SecretString'])    
    except ClientError as e:
      if e.response['Error']['Code'] == 'ResourceNotFoundException':
          logger.error(f'The requested secret ' + secret_name + ' was not found')
      elif e.response['Error']['Code'] == 'InvalidRequestException':
          logger.error(f'The request was invalid due to:', e)
      elif e.response['Error']['Code'] == 'InvalidParameterException':
          logger.error(f'The request had invalid params:', e)
   

## Se conecta a la BD de Registro. Devuelve la informacion realtiva al secreto rotado.
## Devuelve la url del repositorio de git de la aplicación y el fichero que contiene el secreto.
def lambda_handler(event,context):
  logger.info(f'lambda_handler PostgreSQL: ') 

  secret_name = event['queryStringParameters']['secret_name']
  proyect_name = event['queryStringParameters']['proyect_name']

  credential = {} 
  secret = getCredentialsSM(secret_name)
  credential['username'] = secret['username']
  credential['password'] = secret['password']
  credential['host'] = secret['hostname']
  credential['db'] = ['databasename']
  result = {}
  try:     
    connection = pg2.connect(user=credential['username'], password=credential['password'], host=credential['host'], database=credential['db'])
    logger.info(f'Successfully connected to the database...')
    cursor = connection.cursor()
    query = "select repo, file from applications where secretName= %s",[secret_name], " and proyectName= %s",[proyect_name]
    cursor.execute(query)
    logger.info(f'Fetching data from the database...')
    data = cursor.fetchone()
    result['secret_name'] = secret_name
    result['repo_url'] = data[0]
    result['path_secret'] = data[1]   

    return { 'statusCode': 200, 'body':  result} 
  except (Exception, pg2.Error) as error:
     logger.error(f'Error while fetching data from database', error)
  finally:    
    if connection:
      cursor.close()
      connection.close()
      logger.info(f'PostgreSQL connection is closed')

