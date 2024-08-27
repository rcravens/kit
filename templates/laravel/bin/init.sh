#!/usr/bin/env bash

# CODE_REPO_URL
read -p "${GREEN}Enter the Git repository URL [$TEMPLATE_TYPE default]: ${BLUE}" CODE_REPO_URL
echo -e "${RESET}"
export CODE_REPO_URL

# Initialize a new Laravel application
echo "laravel/new_init.sh"
echo "APP_NAME: $APP_NAME"
echo "CODE_REPO_URL: $CODE_REPO_URL"
echo "APP_DIRECTORY: $APP_DIRECTORY"

# COPY .env.example to .env.dev
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=dev|" "${APP_DIRECTORY}/.env.dev"
sed -i .bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.dev"
rm "${APP_DIRECTORY}/.env.dev.bak"

# COPY .env.example to .env.stage
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=stage|" "${APP_DIRECTORY}/.env.stage"
sed -i .bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.stage"
rm "${APP_DIRECTORY}/.env.stage.bak"

# COPY .env.example to .env.prod
cp "${APP_DIRECTORY}/.env.example" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|APP_ENVIRONMENT=.*|APP_ENVIRONMENT=prod|" "${APP_DIRECTORY}/.env.prod"
sed -i .bak "s|CODE_REPO_URL=.*|CODE_REPO_URL=${CODE_REPO_URL}|" "${APP_DIRECTORY}/.env.prod"
rm "${APP_DIRECTORY}/.env.prod.bak"

# Update laravel/.env.dev
if [ -f "${APP_DIRECTORY}/laravel/.env.dev" ]; then
  sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.dev"
  rm "${APP_DIRECTORY}/laravel/.env.dev.bak"
fi

# Update laravel/.env.stage
if [ -f "${APP_DIRECTORY}/laravel/.env.stage" ]; then
  sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.stage"
  rm "${APP_DIRECTORY}/laravel/.env.stage.bak"
fi

# Update laravel/.env.prod
if [ -f "${APP_DIRECTORY}/laravel/.env.prod" ]; then
  sed -i .bak "s|APP_NAME=.*|APP_NAME=${APP_NAME}|" "${APP_DIRECTORY}/laravel/.env.prod"
  rm "${APP_DIRECTORY}/laravel/.env.prod.bak"
fi

