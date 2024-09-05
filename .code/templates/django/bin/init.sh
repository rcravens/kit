#!/usr/bin/env bash

# CODE_REPO_URL
read -p "${GREEN}Enter the Git repository URL [$TEMPLATE_TYPE default]: ${RESET}" CODE_REPO_URL
export CODE_REPO_URL

# HTTP_ON_HOST
read -p "${GREEN}Enter the external port [default: 8000]: ${RESET}" HTTP_ON_HOST
HTTP_ON_HOST=${HTTP_ON_HOST:-8000}
export HTTP_ON_HOST


# Initialize a new Laravel application
#echo "django/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "CODE_REPO_URL: $CODE_REPO_URL"
#echo "APP_DIRECTORY: $APP_DIRECTORY"
#echo "HTTP_ON_HOST: $HTTP_ON_HOST"


# COPY .env.example to the default envs
for env in "${ENVS[@]}"
do
  echo "$i"
  ENV_DIRECTORY="${APP_DIRECTORY}/envs/${env}"
  mkdir -p "${ENV_DIRECTORY}"
  ENV_FILE="${APP_DIRECTORY}/envs/${env}/.env"
  cp "${APP_DIRECTORY}/.env.example" "${ENV_FILE}"
  sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${ENV_FILE}"
  sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${ENV_FILE}"
  sed -i.bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${ENV_FILE}"
  sed -i.bak "s|HTTP_ON_HOST=.*|HTTP_ON_HOST=${HTTP_ON_HOST}|" "${ENV_FILE}"
  rm "${APP_DIRECTORY}/.env.dev.bak"

done
