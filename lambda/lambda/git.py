## Lambda Git 
## La funcion principal recibe como parametros el repositorio de codigo, la ruta de la aplicacion donde 
## modificar el secreto y el secreto.

import os
import json
import boto3
import subprocess
import yq

## funcion para recuperar el valor del secreto a rotar
def getCredentialsSM(secret_name):
    print("Lambda Git getGredentialsSM...")  
    
    credential = {}      
    client = boto3.client(
      service_name='secretsmanager',
      region_name=os.environ['AWS_REGION']   
    )    
    get_secret_value_response = client.get_secret_value(
      SecretId=secret_name
    )    
    secret = json.loads(get_secret_value_response['SecretString'])    
    credential['value'] = secret['value']
    return credential


def lambda_handler(event, context):
    print("Lambda Git lambda_handler...")        

    print('event:', json.dumps(event))
    print('queryStringParameters:', json.dumps(event['queryStringParameters']))
    
    path_secret = event['queryStringParameters']['path_secret']    
    secret_name = event['queryStringParameters']['secret_name']       
    credential = getCredentialsSM(secret_name)
    git_token = '' ## Donde almacenarlo?
    repo_url = event['queryStringParameters']['repo_url']
            
    # Se clona el repositorio en el directorio /tmp
    try:
        subprocess.check_call(['git', 'clone', 'https://'+ git_token + repo_url, '/tmp/repo'])
        print("Successfully cloned the repository: ", e)
    except subprocess.CalledProcessError as e:
        print("Error to clone repository: ", e)
    
    # Se actualiza el secrets.yaml con el valor del secreto  
    # Acceder al path del fichero secrets.yaml
    os.chdir(path_secret)
    print("Path to conf-k8s secret directory:", os.getcwd())
    
    # Actualizar el yaml
    #yq -yi ".data."secret_name =  credential['value'] secret_file 
      
    # Se realiza el commit y el push al repositorio
    try:
        subprocess.check_call(['git', 'commit', '-m', 'AWS Secrets Manager: RDS secret rotation'])
        subprocess.check_call(['git', 'push'], cwd="/tmp/repo")
        print("Successfully pushed code to the repository: ", e)       
    except subprocess.CalledProcessError as e:             
        print("Error pushing code...", e)        
  
