#!/usr/bin/env python3

# managed with ansible

import requests
import os

# Create the previous_ip.txt file if it doesn't exist
# lazy disclaimer: this creates this file in /root/previous_ip.txt
if not os.path.exists('previous_ip.txt'):
  with open('previous_ip.txt', 'w') as file:
    pass

def get_external_ip():
  response = requests.get('https://api.ipify.org')
  return response.text

def send_push_notification(message):
  # Replace with your Pushover API token and user key
  api_token = "{{ pushover_token_ip_check }}"
  user_key = "{{ pushover_user_ip_check }}"

  data = {
    'token': api_token,
    'user': user_key,
    'message': message
  }

  response = requests.post('https://api.pushover.net/1/messages.json', data=data)
  return response.status_code == 200

def main():
  # Load the previous IP address from a file
  with open('previous_ip.txt', 'r') as file:
    previous_ip = file.read().strip()

  # Get the current external IP address
  current_ip = get_external_ip()

  if current_ip != previous_ip:
    # Save the new IP address to the file
    with open('previous_ip.txt', 'w') as file:
      file.write(current_ip)

    # Send a push notification
    message = f'{{ external_ip_monitor_message_location }} IP address has changed from {previous_ip} to {current_ip}'
    send_push_notification(message)

if __name__ == '__main__':
  main()
