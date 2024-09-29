#!/usr/bin/env bash

function make_run {
  if [ "$ARGS" == "help" ]; then
     make_help
     return 1
  fi

  NAME=$1
  if [ -z "$NAME" ]; then
    echo_red "Please provide a deployment server name."
    exit 1
  fi

  SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${NAME}"
  if [ -d "$SERVER_DIRECTORY" ]; then
    echo_red "This deployment server already exists. Choose a different name."
    exit 1
  fi

  # create directories
  mkdir -p "$SERVER_DIRECTORY/.ssh"

  # create inventory.yml
  #cp "$BIN_DIRECTORY/files/swarm_inventory_template.yml" "$SERVER_DIRECTORY/inventory.yml"

  # create server_settings.yml
  CLOUD_PROVIDER="aws"
  cat <<XXX > "$SERVER_DIRECTORY/server_settings.yml"
---
cloud_provider: ${CLOUD_PROVIDER}

XXX

  # create swarm_settings.yml
  cp "$BIN_DIRECTORY/files/swarm_settings_template.yml" "$SERVER_DIRECTORY/swarm_settings.yml"

  echo_green "Deployment server '$NAME' created successfully: ${SERVER_DIRECTORY}."
}

function make_help() {
  echo_command "kit make server <NAME>" "Make a new deployment server."
}