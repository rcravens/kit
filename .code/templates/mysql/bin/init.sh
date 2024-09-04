#!/usr/bin/env bash

# MYSQL_ON_HOST
read -p "${GREEN}Enter the external port [default: 33061]: ${RESET}" MYSQL_ON_HOST
MYSQL_ON_HOST=${MYSQL_ON_HOST:-33061}
export MYSQL_ON_HOST

# MYSQL_DATABASE
read -p "${GREEN}Enter a database name [default: myapp]: ${RESET}" MYSQL_DATABASE
MYSQL_DATABASE=${MYSQL_DATABASE:-myapp}
export MYSQL_DATABASE

# MYSQL_USERNAME
read -p "${GREEN}Database username [default: myapp_user]: ${RESET}" MYSQL_USERNAME
MYSQL_USERNAME=${MYSQL_USERNAME:-myapp_user}
export MYSQL_USERNAME

# MYSQL_PASSWORD
read -p "${GREEN}Database password [default: secret]: ${RESET}" MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-secret}
export MYSQL_PASSWORD

# MYSQL_ROOT_PASSWORD
read -p "${GREEN}Root database password [default: secret]: ${RESET}" MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-secret}
export MYSQL_ROOT_PASSWORD


# Initialize a new Laravel application
#echo "mysql/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "APP_DIRECTORY: $APP_DIRECTORY"
#echo "MYSQL_ON_HOST: $MYSQL_ON_HOST"
#echo "MYSQL_DATABASE: $MYSQL_DATABASE"
#echo "MYSQL_USERNAME: $MYSQL_USERNAME"
#echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
#echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_ON_HOST=.*|MYSQL_ON_HOST=${MYSQL_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_DATABASE=.*|MYSQL_DATABASE=${MYSQL_DATABASE}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_USERNAME=.*|MYSQL_USERNAME=${MYSQL_USERNAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${MYSQL_PASSWORD}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}|" "${APP_DIRECTORY}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_ON_HOST=.*|MYSQL_ON_HOST=${MYSQL_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_DATABASE=.*|MYSQL_DATABASE=${MYSQL_DATABASE}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_USERNAME=.*|MYSQL_USERNAME=${MYSQL_USERNAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_PASSWORD=.*|MYSQL_PASSWORD=${MYSQL_PASSWORD}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_ROOT_PASSWORD=.*|MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"


