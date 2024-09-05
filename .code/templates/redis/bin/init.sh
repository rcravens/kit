#!/usr/bin/env bash

# REDIS_ON_HOST
read -p "${GREEN}Enter the external port [default: 6379]: ${RESET}" REDIS_ON_HOST
REDIS_ON_HOST=${REDIS_ON_HOST:-6379}
export REDIS_ON_HOST

# Initialize a new Laravel application
#echo "redis/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "REDIS_ON_HOST: REDIS_ON_HOST"

# COPY .env.example to default environments
for env in "${ENVS[@]}"
do
  ENV_DIRECTORY="${APP_DIRECTORY}/envs/${env}"
  mkdir -p "${ENV_DIRECTORY}"
  ENV_FILE="${APP_DIRECTORY}/envs/${env}/.env"
  cp "${APP_DIRECTORY}/.env.example" "${ENV_FILE}"
  sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${ENV_FILE}"
  sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${ENV_FILE}"
  sed -i.bak "s|REDIS_ON_HOST=.*|MYSQL_ON_HOST=${REDIS_ON_HOST}|" "${ENV_FILE}"
  rm "${ENV_FILE}.bak"
done
