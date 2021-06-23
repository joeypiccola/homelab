from __future__ import print_function
from random import randrange
import sys
import ssl
import time
import datetime
import logging, traceback
import json
import paho.mqtt.client as mqtt
# https://aws.amazon.com/blogs/iot/how-to-implement-mqtt-with-tls-client-authentication-on-port-443-from-client-devices-python/

IoT_protocol_name = "x-amzn-mqtt-ca"
aws_iot_endpoint = 'x.iot.us-east-1.amazonaws.com'
url = "https://{}".format(aws_iot_endpoint)

ca = '/Users/jpiccola/Documents/github/homelab/terraform/aws_iot_timestream/iot_cert/AmazonRootCA1.pem'
cert = '/Users/jpiccola/Documents/github/homelab/terraform/aws_iot_timestream/iot_cert/cert.pem'
private = '/Users/jpiccola/Documents/github/homelab/terraform/aws_iot_timestream/iot_cert/private_key.pem'

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
handler = logging.StreamHandler(sys.stdout)
log_format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(log_format)
logger.addHandler(handler)

def ssl_alpn():
    try:
        #debug print opnessl version
        logger.info("open ssl version:{}".format(ssl.OPENSSL_VERSION))
        ssl_context = ssl.create_default_context()
        ssl_context.set_alpn_protocols([IoT_protocol_name])
        ssl_context.load_verify_locations(cafile=ca)
        ssl_context.load_cert_chain(certfile=cert, keyfile=private)

        return  ssl_context
    except Exception as e:
        print("exception ssl_alpn()")
        raise e

if __name__ == '__main__':
    topic = 'home/sensors/test_thing2'
    try:
        mqttc = mqtt.Client(client_id='test_thing2')
        ssl_context= ssl_alpn()
        mqttc.tls_set_context(context=ssl_context)
        logger.info("start connect")
        mqttc.connect(aws_iot_endpoint, port=443)
        logger.info("connect success")
        mqttc.loop_start()

        while True:
            rand = randrange(1,10)
            payload={"temperature":randrange(rand),"location":"attic"}
            payloadjson=json.dumps(payload)
            logger.info("try to publish:{}".format(rand))
            mqttc.publish(topic, payloadjson)
            time.sleep(10)

    except Exception as e:
        logger.error("exception main()")
        logger.error("e obj:{}".format(vars(e)))
        logger.error("message:{}".format(e.message))
        traceback.print_exc(file=sys.stdout)
