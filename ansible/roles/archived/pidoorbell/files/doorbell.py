#!/usr/bin/python3

# setup python
import time
import RPi.GPIO as GPIO
import http.client, urllib
import requests

# define pins
buttonPin = 23
buttonOpenLED = 6 # red
buttonClosedLED = 19 # green

# setup GPIO and pins
GPIO.setmode(GPIO.BCM)
GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(buttonOpenLED, GPIO.OUT)
GPIO.setup(buttonClosedLED, GPIO.OUT)

try:
    while True:
        # sleep a bit to keep CPU from going crazy
        time.sleep(.1)
        # read button input
        buttonState = GPIO.input(buttonPin)
        # if we're false then signal has gone to ground and button has been pushed
        if buttonState == False:
            # turn off red led and turn on green led
            GPIO.output(buttonOpenLED, 0)
            GPIO.output(buttonClosedLED, 1)
            # get snapshot from blueiris NVR (front_porch_hd cam) and save file locally
            url = "http://{{ blueiris_ip }}:81/image/front_porch_hd&user={{ blueiris_user }}&pw={{ blueiris_pass }}"
            urllib.request.urlretrieve(url, '/home/pi/snapshot.jpg')
            # notify pushover
            r_pushover = requests.post("https://api.pushover.net/1/messages.json",
                data = {
                    "token": "{{ pushover_token }}",
                    "user": "{{ pushover_user }}",
                    "message": "Doorbell was pushed."
                },
                files = {
                    "attachment": ("image.jpg", open("/home/pi/snapshot.jpg", "rb"), "image/jpeg")
                }
            )
            # sleep to prevent repeat button presses
            time.sleep(5)
            # turn on red led and turn off green led
            GPIO.output(buttonOpenLED, 1)
            GPIO.output(buttonClosedLED, 0)
        else:
            # turn on red led
            GPIO.output(buttonOpenLED, 1)

except KeyboardInterrupt:          # trap a CTRL+C keyboard interrupt
    GPIO.cleanup()
