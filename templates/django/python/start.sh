#!/usr/bin/env bash

cd /app/code

# Ensure django project exists
if ! [ -e manage.py ]; then
  django-admin startproject my_site .
  pip freeze > requirements.txt
fi

# Install required python packages
pip install --no-cache-dir -r requirements.txt

# wait until postgres is up and ready for connections
while !</dev/tcp/postgres/5432;
do
  echo 'waiting for postgres....'
  sleep 1;
done;

# perform django db migrations
python manage.py migrate

# collect static files
python manage.py collectstatic --noinput

# run the server
python manage.py runserver 0.0.0.0:8080
# can't seem to get gunicorn to reload changed files....okay for prod....not for dev
#gunicorn my_site.wsgi:application --bind 0.0.0.0:8080 --reload --reload-extra-file /app/code