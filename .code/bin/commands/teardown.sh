#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

  SERVER=$ARGS

  SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${SERVER}"
  SSH_DIR="${SERVER_DIRECTORY}/.ssh"

  AWS_DIR="${SERVER_DIRECTORY}/.aws"
  if [ ! -d "$AWS_DIR" ]; then
    AWS_DIR="$HOME/.aws"
  fi

  echo "APP: ${APP}"
  echo "ROOT_DIRECTORY: ${ROOT_DIRECTORY}"
  echo "SERVER: ${SERVER}"
  echo "SSH_DIR: ${SSH_DIR}"
  echo "AWS_DIR: ${AWS_DIR}"

  if [ -z "$SERVER" ]; then
    echo_red "Server name is required."
    exit 1
  fi

  if [ ! -d "$SSH_DIR" ]; then
    echo_red "SSH directory not found: ${SSH_DIR}"
    exit 1
  fi

  if [ ! -d "$AWS_DIR" ]; then
    echo_red "AWS credential directory not found: ${AWS_DIR}"
    exit 1
  fi

#  docker run --rm --pull=always -it \
#    -v "$INVENTORY_FILE":/ansible/inventory.yml \
#    -v "$SERVER_SETTINGS_FILE":/ansible/server_settings.yml \
#    -v "$SSH_DIR":/root/.ssh \
#    -v "$AWS_DIR":/root/.aws \
#    rcravens/ansible ansible-playbook playbooks/sandbox.yml

  run_ansible "$SERVER" \
   playbooks/teardown.yml
}

function command_help() {
  echo_command "kit teardown <dest>" "Shutdown and delete the nodes for this server."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit teardown <dest>"
    echo_divider
}