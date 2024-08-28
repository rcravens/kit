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

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|POSTGRES_ON_HOST=.*|POSTGRES_ON_HOST=${POSTGRES_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|POSTGRES_DB=.*|POSTGRES_DB=${POSTGRES_DB}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|POSTGRES_USER=.*|POSTGRES_USER=${POSTGRES_USER}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${POSTGRES_PASSWORD}|" "${APP_DIRECTORY}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.stage
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=stage|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|POSTGRES_ON_HOST=.*|POSTGRES_ON_HOST=${POSTGRES_ON_HOST}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|POSTGRES_DB=.*|POSTGRES_DB=${POSTGRES_DB}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|POSTGRES_USER=.*|POSTGRES_USER=${POSTGRES_USER}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${POSTGRES_PASSWORD}|" "${APP_DIRECTORY}/.env.stage"
rm "${APP_DIRECTORY}/.env.stage.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|POSTGRES_ON_HOST=.*|POSTGRES_ON_HOST=${POSTGRES_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|POSTGRES_DB=.*|POSTGRES_DB=${POSTGRES_DB}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|POSTGRES_USER=.*|POSTGRES_USER=${POSTGRES_USER}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${POSTGRES_PASSWORD}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"


