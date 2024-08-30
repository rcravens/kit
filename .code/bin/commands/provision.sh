#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    SERVER=$ARGS
    SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${SERVER}"
    INVENTORY_FILE="${SERVER_DIRECTORY}/inventory.yml"
    DEPLOY_SETTINGS_FILE="${SERVER_DIRECTORY}/deploy_settings.yml"
    SSH_DIR="${SERVER_DIRECTORY}/.ssh"

    echo "ROOT_DIRECTORY: ${ROOT_DIRECTORY}"
    echo "SERVER: ${SERVER}"
    echo "INVENTORY_FILE: ${INVENTORY_FILE}"
    echo "DEPLOY_SETTINGS_FILE: ${DEPLOY_SETTINGS_FILE}"
    echo "SSH_DIR: ${SSH_DIR}"

    if [ ! -f "$INVENTORY_FILE" ]; then
      echo_red "Inventory file not found: ${INVENTORY_FILE}"
      exit 1
    fi

    if [ ! -d "$SSH_DIR" ]; then
      echo_red "SSH directory not found: ${SSH_DIR}"
      exit 1
    fi

#    docker run --rm --pull=always -it \
#      -v "$INVENTORY_FILE":/ansible/inventory.yml \
#      -v "$DEPLOY_SETTINGS_FILE":/ansible/deploy_settings.yml \
#      -v "$SSH_DIR":/root/.ssh \
#      -v ~/.aws:/root/.aws \
#      rcravens/ansible /bin/sh
#    exit 1

    docker run --rm --pull=always -it \
      -v "$INVENTORY_FILE":/ansible/inventory.yml \
      -v "$DEPLOY_SETTINGS_FILE":/ansible/deploy_settings.yml \
      -v "$SSH_DIR":/root/.ssh \
      -v ~/.aws:/root/.aws \
      rcravens/ansible ansible-playbook playbooks/configure.yml
}

function command_help() {
  echo_command "kit provision" "Provision Docker Swarm in AWS"
}

function command_help_details() {
    echo_divider
    echo_red "Before running this command be sure to copy 'deploy-example.yml' to 'deploy.yml' and update deployment data."
    echo "Examples:"
    echo_example "kit provision"
    echo_divider
}