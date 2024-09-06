#!/usr/bin/env bash

# For each of the existing environments, use the .env.template file
# as a template to create a new environment file with the correct environment variables.
ENV_DIRECTORY="${APP_DIRECTORY}/envs/*"
for DIR in ${ENV_DIRECTORY}; do
  env="${DIR##*/}"

  echo_yellow "Updating environment: ${env}"

  ENV_TEMPLATE_FILE="${APP_DIRECTORY}/envs/.env.template"
  ENV_FILE="${APP_DIRECTORY}/envs/${env}/.env"

  update_env_using_template "$ENV_TEMPLATE_FILE" "$ENV_FILE"
done
