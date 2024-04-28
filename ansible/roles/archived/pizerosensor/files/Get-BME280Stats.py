#!/usr/bin/env python3
import time
import json
import board
import busio
import adafruit_bme280
import sys
i2c = busio.I2C(board.SCL, board.SDA)
# pass address 0x76 to override default 0x76
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c,address=0x76)
temp = "%0.2f" % ((bme280.temperature * 1.8) + 32)
humidity = "%0.1f" % (bme280.humidity)
data = {"temperature": float(temp), "humidity": float(humidity)}
json_data = json.dumps(data)
print (json_data)