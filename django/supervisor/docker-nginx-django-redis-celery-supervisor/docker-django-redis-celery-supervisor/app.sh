#!/bin/sh

# Python Application
/usr/local/bin/python3 /app/manage.py migrate && /usr/local/bin/python3 /app/manage.py wait_for_db && /usr/local/bin/python3 /app/manage.py runserver 0.0.0.0:8000

# End