#!/usr/bin/env bash

# POSTGRES_ON_HOST
read -p "${GREEN}Enter the external port [default: 5432]: ${RESET}" POSTGRES_ON_HOST
POSTGRES_ON_HOST=${POSTGRES_ON_HOST:-5432}
export POSTGRES_ON_HOST

# POSTGRES_DB
read -p "${GREEN}Enter a database name [default: myapp]: ${RESET}" POSTGRES_DB
POSTGRES_DB=${POSTGRES_DB:-myapp}
export POSTGRES_DB

# POSTGRES_USER
read -p "${GREEN}Database username [default: myapp_user]: ${RESET}" POSTGRES_USER
POSTGRES_USER=${POSTGRES_USER:-myapp_user}
export POSTGRES_USER

# POSTGRES_PASSWORD
read -p "${GREEN}Database password [default: secret]: ${RESET}" POSTGRES_PASSWORD
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-secret}
export POSTGRES_PASSWORD

# Initialize a new Laravel application
#echo "postgres/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "APP_DIRECTORY: $APP_DIRECTORY"
#echo "POSTGRES_ON_HOST: $POSTGRES_ON_HOST"
#echo "POSTGRES_DB: $POSTGRES_DB"
#echo "POSTGRES_USER: $POSTGRES_USER"
#echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"

# COPY .env.example to default environments
for env in "${ENVS[@]}"
do
  ENV_DIRECTORY="${APP_DIRECTORY}/envs/${env}"
  mkdir -p "${ENV_DIRECTORY}"
  ENV_FILE="${APP_DIRECTORY}/envs/${env}/.env"
  cp "${APP_DIRECTORY}/.env.example" "${ENV_FILE}"
  sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${ENV_FILE}"
  sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${ENV_FILE}"
  sed -i.bak "s|POSTGRES_ON_HOST=.*|POSTGRES_ON_HOST=${POSTGRES_ON_HOST}|" "${ENV_FILE}"
  sed -i.bak "s|POSTGRES_DB=.*|POSTGRES_DB=${POSTGRES_DB}|" "${ENV_FILE}"
  sed -i.bak "s|POSTGRES_USER=.*|POSTGRES_USER=${POSTGRES_USER}|" "${ENV_FILE}"
  sed -i.bak "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${POSTGRES_PASSWORD}|" "${ENV_FILE}"
  rm "${ENV_FILE}.bak"
done

