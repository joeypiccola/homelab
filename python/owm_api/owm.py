from flask import Flask
from flask_restful import Resource, Api, reqparse
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import requests

app     = Flask(__name__)
api     = Api(app=app)
limiter = Limiter(app=app,key_func=get_remote_address)

# setup RequestParser
parser = reqparse.RequestParser(trim=True)
parser.add_argument(name='zip_code', required=True)
parser.add_argument(name='token', required=True)
parser.add_argument(name='country', default='us')
parser.add_argument(name='units', default='imperial')

# define owm class as resource type from flask_restful
class owm(Resource):
    # use 1/2 limit of actual OWM free limit of (60/minute)
    decorators = [limiter.limit(limit_value="30/minute")]
    def post(self):
        args = parser.parse_args()
        zip_code = args['zip_code']
        token = args['token']
        country = args['country']
        units = args['units']
        openweather_uri = "https://api.openweathermap.org/data/2.5/weather?zip={},{}&appid={}&units={}".format(zip_code,country,token,units)
        response = requests.get(url=openweather_uri)
        return response.json()

# add class as resource to api
api.add_resource(owm,'/owm')

# run app only when called directly (e.g. python3 owm.py or gunicorn -args)
if __name__ == '__main__':
    app.run()
