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
  sed -i.bak "s|HTTPS_ON_HOST=.*|HTTPS_ON_HOST=${HTTPS_ON_HOST}|" "${ENV_FILE}"
  sed -i.bak "s|MYSQL_ON_HOST=.*|MYSQL_ON_HOST=${MYSQL_ON_HOST}|" "${ENV_FILE}"
  sed -i.bak "s|REDIS_ON_HOST=.*|REDIS_ON_HOST=${REDIS_ON_HOST}|" "${ENV_FILE}"
  rm "${ENV_FILE}.bak"

  # Update laravel/.env.dev
  if [ -f "${APP_DIRECTORY}/envs/${env}/laravel/.env" ]; then
    sed -i.bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/envs/${env}/laravel/.env"
    sed -i.bak "s|DB_DATABASE=.*|DB_DATABASE=${APP_NAME}|" "${APP_DIRECTORY}/envs/${env}/laravel/.env"
    rm "${APP_DIRECTORY}/envs/${env}/laravel/.env.bak"
  fi
done
