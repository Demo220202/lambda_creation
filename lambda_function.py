def lambda_handler(event, context):
    print('Hello from Addy!')
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
