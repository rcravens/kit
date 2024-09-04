#!/usr/bin/env bash

# CODE_REPO_URL
read -p "${GREEN}Enter the Git repository URL [$TEMPLATE_TYPE default]: ${RESET}" CODE_REPO_URL
export CODE_REPO_URL

# HTTP_ON_HOST
read -p "${GREEN}Enter the external port [default: 8090]: ${RESET}" HTTP_ON_HOST
HTTP_ON_HOST=${HTTP_ON_HOST:-8090}
export HTTP_ON_HOST


# Initialize a new Laravel application
#echo "django/new_init.sh"
#echo "APP_NAME: $APP_NAME"
#echo "CODE_REPO_URL: $CODE_REPO_URL"
#echo "APP_DIRECTORY: $APP_DIRECTORY"
#echo "HTTP_ON_HOST: $HTTP_ON_HOST"

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|HTTP_ON_HOST=.*|HTTP_ON_HOST=${HTTP_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|HTTP_ON_HOST=.*|HTTP_ON_HOST=${HTTP_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"

