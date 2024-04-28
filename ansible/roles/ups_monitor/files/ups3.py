#!/usr/bin/env python3

# managed with ansible

# setup python
import requests
import sys

message = sys.argv[1]

json = {
  "token": "{{ pushover_token_ups_monitor }}",
  "user": "{{ pushover_user_ups_monitor }}",
  "message": message,
}

headers = {"Content-Type": "application/json"}

url = 'https://api.pushover.net:443/1/messages.json'
r = requests.post(url, headers=headers, json=json)
r

