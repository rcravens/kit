#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi
#    echo_red "Coming Soon"
#    exit 1

    SERVER=$ARGS
    INVENTORY_FILE="${ROOT_DIRECTORY}/servers/${SERVER}/inventory.yml"
    SSH_DIR="${ROOT_DIRECTORY}/servers/${SERVER}/.ssh"
    STACK_FILE="${APP_DIRECTORY}/deploy.yml"
    echo "ROOT_DIRECTORY: ${ROOT_DIRECTORY}"
    echo "SERVER: ${SERVER}"
    echo "INVENTORY_FILE: ${INVENTORY_FILE}"
    echo "SSH_DIR: ${SSH_DIR}"
    echo "STACK_FILE: ${STACK_FILE}"
    echo "APPLICATION: ${APP}"

    if [ ! -f "$INVENTORY_FILE" ]; then
      echo_red "Inventory file not found: ${INVENTORY_FILE}"
      exit 1
    fi

    if [ ! -d "$SSH_DIR" ]; then
      echo_red "SSH directory not found: ${SSH_DIR}"
      exit 1
    fi

    if [ ! -f "$STACK_FILE" ]; then
      echo_red "Stack file not found: ${STACK_FILE}"
      exit 1
    fi

#    docker run --rm --pull=always -it \
#      -v "$INVENTORY_FILE":/ansible/inventory.yml \
#      -v "$SSH_DIR":/root/.ssh \
#      -v "$STACK_FILE":/ansible/playbooks/swarm/stacks/"$APP".yml \
#      -v ~/.aws:/root/.aws \
#      rcravens/ansible /bin/sh
#
#    exit 1
#
#    envsubst < "${TEMPLATE_FILE}" > "${STACK_FILE}"
#
#    sed -i '' '/platform: linux\/amd64/d' "${STACK_FILE}"



    docker run --rm --pull=always -it \
      -v "$INVENTORY_FILE":/ansible/inventory.yml \
      -v "$SSH_DIR":/root/.ssh \
      -v "$STACK_FILE":/ansible/playbooks/swarm/stacks/"$APP".yml \
      -v ~/.aws:/root/.aws \
      rcravens/ansible ansible-playbook playbooks/deploy.yml
}

function command_help() {
  echo_command "kit deploy" "Deploy application to Docker Swarm in AWS"
}

function command_help_details() {
    echo_divider
    echo_red "Before running this command be sure to copy 'deploy-example.yml' to 'deploy.yml' and update deployment data."
    echo "Examples:"
    echo_example "kit deploy"
    echo_divider
}