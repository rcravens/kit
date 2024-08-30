#!/usr/bin/env bash

if [ ! -f "requirements.txt" ]; then
  django-admin startproject proj .
  pip freeze > requirements.txt
fi

# Start the python server
python manage.py runserver 0.0.0.0:8000