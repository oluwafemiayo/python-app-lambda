def lambda_handler(event, context):
    message = 'hello from Lagos Nigeria {} !' .format(event['key1'])
    return {
        'message': message
    }