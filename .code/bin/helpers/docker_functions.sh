#!/usr/bin/env bash

# Helper function to run docker compose commands
function run_docker_compose()
{
#  set -o xtrace
  # Main compose file
  COMPOSE_FILES=("-f" "${APP_DIRECTORY}/docker-compose.yml")
  if [ -f "${APP_DIRECTORY}/envs/${ENV}/docker-compose.yml" ]; then
    # Found an override compose file in the ENV directory
    COMPOSE_FILES+=("-f" "${APP_DIRECTORY}/envs/${ENV}/docker-compose.yml")
  fi
  docker compose "${COMPOSE_FILES[@]}" --env-file "${ENV_FILE}" "$@"
#  set +o xtrace
}