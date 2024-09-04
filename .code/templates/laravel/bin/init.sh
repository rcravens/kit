#!/usr/bin/env bash


# CODE_REPO_URL
read -p "${GREEN}Enter the Git repository URL [$TEMPLATE_TYPE default]: ${RESET}" CODE_REPO_URL
export CODE_REPO_URL

# HTTP_ON_HOST
read -p "${GREEN}Enter HTTP port [default: 8001]: ${RESET}" HTTP_ON_HOST
export HTTP_ON_HOST=${HTTP_ON_HOST:-8001}

# HTTPS_ON_HOST=44301
read -p "${GREEN}Enter the HTTPS port [default: 44301]: ${RESET}" HTTPS_ON_HOST
export HTTPS_ON_HOST=${HTTPS_ON_HOST:-44301}

# MYSQL_ON_HOST=33061
read -p "${GREEN}Enter the MySQL port [default: 33061]: ${RESET}" MYSQL_ON_HOST
export MYSQL_ON_HOST=${MYSQL_ON_HOST:-33061}

# REDIS_ON_HOST=63791
read -p "${GREEN}Enter the Redis port [default: 63791]: ${RESET}" REDIS_ON_HOST
export REDIS_ON_HOST=${REDIS_ON_HOST:-63791}


# Initialize a new Laravel application
echo "laravel/new_init.sh"
echo "APP_NAME: $APP_NAME"
echo "CODE_REPO_URL: $CODE_REPO_URL"
echo "APP_DIRECTORY: $APP_DIRECTORY"
echo "HTTP_ON_HOST: $HTTP_ON_HOST"
echo "HTTPS_ON_HOST: $HTTPS_ON_HOST"
echo "MYSQL_ON_HOST: $MYSQL_ON_HOST"
echo "REDIS_ON_HOST: $REDIS_ON_HOST"

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|HTTP_ON_HOST=.*|HTTP_ON_HOST=${HTTP_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|HTTPS_ON_HOST=.*|HTTPS_ON_HOST=${HTTPS_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|MYSQL_ON_HOST=.*|MYSQL_ON_HOST=${MYSQL_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
sed -i.bak "s|REDIS_ON_HOST=.*|REDIS_ON_HOST=${REDIS_ON_HOST}|" "${APP_DIRECTORY}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|HTTP_ON_HOST=.*|HTTP_ON_HOST=${HTTP_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|HTTPS_ON_HOST=.*|HTTPS_ON_HOST=${HTTPS_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|MYSQL_ON_HOST=.*|MYSQL_ON_HOST=${MYSQL_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
sed -i.bak "s|REDIS_ON_HOST=.*|REDIS_ON_HOST=${REDIS_ON_HOST}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"


# Update laravel/.env.dev
if [ -f "${APP_DIRECTORY}/laravel/.env.dev" ]; then
  sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.dev"
  sed -i.bak "s|DB_DATABASE=.*|DB_DATABASE=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.dev"
  rm "${APP_DIRECTORY}/laravel/.env.dev.bak"
fi

# Update laravel/.env.prod
if [ -f "${APP_DIRECTORY}/laravel/.env.prod" ]; then
  sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.prod"
  sed -i.bak "s|DB_DATABASE=.*|DB_DATABASE=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.prod"
  rm "${APP_DIRECTORY}/laravel/.env.prod.bak"
fi

