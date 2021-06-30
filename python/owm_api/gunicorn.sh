#!/bin/sh
gunicorn -w 2 -t 2 -b 0.0.0.0:5000 owm:app
