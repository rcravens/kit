#!/usr/bin/env bash

# REDIS_ON_HOST
read -p "${GREEN}Enter the external port [default: 6379]: ${RESET}" REDIS_ON_HOST
REDIS_ON_HOST=${REDIS_ON_HOST:-6379}
export REDIS_ON_HOST

# Initialize a new Laravel application
#echo "redis/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "REDIS_ON_HOST: REDIS_ON_HOST"

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|REDIS_ON_HOST=.*|MYSQL_ON_HOST=${REDIS_ON_HOST}|" "${REDIS_ON_HOST}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.stage
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=stage|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|REDIS_ON_HOST=.*|REDIS_ON_HOST=${REDIS_ON_HOST}|" "${APP_DIRECTORY}/.env.stage"
rm "${APP_DIRECTORY}/.env.stage.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|REDIS_ON_HOST=.*|REDIS_ON_HOST=${REDIS_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"


