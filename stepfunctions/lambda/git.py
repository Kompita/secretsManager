import os
import json
import yaml
import boto3
import logging
import subprocess
from boto3.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Modifica el yaml que contiene el valor del secreto a rotar
# Devuelve el yaml rotado
def writeYaml(path_secret, secret_name, secret_value):
    logger.info(f'writeYaml:')    
    loaded = {}
    try:
        with open(path_secret, 'r') as stream:
            loaded = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        logger.error(f'Error in load yaml:', exc)    
    # Modify the fields from the dict
    loaded['data'][secret_name] = secret_value    
    try:
        with open(path_secret, 'w') as stream:
            yaml.dump(loaded, stream, default_flow_style=False)
    except yaml.YAMLError as exc:
        logger.error(f'Error in dump yaml:', exc)


# Solicita a Secrets Manager el valor del secreto rotado
# Devuelve un objeto que contiene el valor del secreto
def getCredentials(secret_name):
    logger.info(f'getGredentials:')
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
            logger.error(f'The requested secret ' +
                         secret_name + ' was not found')
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            logger.error(f'The request was invalid due to:', e)
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            logger.error(f'The request had invalid params:', e)


# Solicita a SM el valor del ecreto y rotado y actualiza el repositorrio de la aplicación
# Recibe como parametros el nombre del secreto, la url del repositorio y el fichero de secretos
def lambda_handler(event, context):
    logger.info(f'lambda_handler to upgrade git: {event}')

    request_data = event['queryStringParameters']
    secret_name = request_data['secret_name']
    path_secret = request_data['path_secret']
    repo_url = request_data['repo_url']    

    # Se obtiene el valor del secreto rotado
    secret = getCredentials(secret_name)    

    # Se clona el repositorio en el directorio /tmp
    try:
        subprocess.check_call(['git', 'clone', repo_url, '/tmp/repo'])
    except subprocess.CalledProcessError as e:
        print("Error in clone: ", e)
        return

    # Acceder al path del fichero secrets.yaml
    os.chdir(path_secret)
    print("Path to conf-k8s secret directory:", os.getcwd())

    # Actualizar el yaml  
    writeYaml(path_secret, secret_name, secret['value'])

    # Se realiza el commit y el push al repositorio
    try:
        subprocess.check_call(
            ['git', 'commit', '-m', 'AWS Secrets Manager: RDS secret rotation'])
        subprocess.check_call(['git', 'push'], cwd="/tmp/repo")
        logger.info(f'Lambda Git: push')
    except subprocess.CalledProcessError as e:
        print("Error al hacer push: ", e)
        return
    print("Code repository upgraded successfully")
