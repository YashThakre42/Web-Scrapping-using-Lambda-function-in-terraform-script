import requests
import boto3
from botocore.client import Config
from botocore.exceptions import NoCredentialsError
import os

def lambda_handler(event, context):
    
    # Define URL
    url = "https://www.amazon.com/"
    
    # Define S3 parameters
    bucket_name = 'ygt-web-scrap-bucket2'
    object_name = 'terra-webpage-content.html'
    
    config = Config(connect_timeout=900, read_timeout=900, retries={'max_attempts': 10})
    s3 = boto3.client('s3', config=config)
    
    try:
       
        response = requests.get(url, timeout=10)
            
        if response.status_code == 200:
            webpage_content = response.text
            s3.put_object(Bucket=bucket_name, Key=object_name, Body=webpage_content)
            return {
                'statusCode': 200,
                'body': 'Webpage content fetched and stored in S3 successfully!'
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': 'Failed to fetch the webpage content.'
            }
    
    
    except requests.exceptions.RequestException as e:
            return {
                 'statusCode': 500,
                 'body': f"Error occurred: {str(e)}"
            }
         
