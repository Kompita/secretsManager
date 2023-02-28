## Lambda Git 
## La funcion principal recibe como parametros el repositorio de codigo, la ruta de la aplicacion donde 
## modificar el secreto y el secreto.

import os
import sys
import logging
import subprocess

sys.path.append('./libs/pyyaml')

logger = logging.getLogger()
logger.setLevel(logging.INFO)


# Parametros de entrada:
## Sercret Name
def lambda_handler(event, context):
    logger.info(f'Lambda Git: {event}')    
    
    request_data = event['queryStringParameters']
    secret_name = request_data['secret_name']
    secret_value = request_data['secret_value']
    #path_url = "soporte-alma-diagramas-conf-k8s/secret/"
    path_secret = request_data['path_secret']
    #repo_url "https://icprov.correos.es/git/soporte/alma/ri/soporte-alma-diagramas-conf-k8s"
    repo_url = request_data['repo_url']
    secret_file = request_data['secret_file']
    
    # Se clona el repositorio en el directorio /tmp
    try:
        subprocess.check_call(['git', 'clone', repo_url, '/tmp/repo'])
    except subprocess.CalledProcessError as e:
        print("Error al clonar el repositorio: ", e)
        return

    # Se actualiza el secrets.yaml con el valor del secreto  
    # Acceder al path del fichero secrets.yaml
    os.chdir(path_secret)
    print("Path to conf-k8s secret directory:", os.getcwd())
    
    # Actualizar el yaml
    yq w secret_file "data.BBDD_PASSWORD_APP.value" secret_value
    
    # Se realiza el commit y el push al repositorio
    try:
        subprocess.check_call(['git', 'commit', '-m', 'AWS Secrets Manager: RDS secret rotation'])
        subprocess.check_call(['git', 'push'], cwd="/tmp/repo")
        logger.info(f'Lambda Git: push')            
    except subprocess.CalledProcessError as e:             
        print("Error al hacer push: ", e)
        return
    print("El repositorio de código se actualiza con éxito")
