#!/usr/bin/env bash

function make_run {
  if [ "$ARGS" == "help" ]; then
     make_help
     return 1
  fi

  NAME=$1

  SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${NAME}"
  if [ -d "$SERVER_DIRECTORY" ]; then
    echo_red "This deployment server already exists. Choose a different name."
    exit 1
  fi

  # create directories
  mkdir -p "$SERVER_DIRECTORY/.ssh"

  # create inventory.yml
  cat <<XXX > "$SERVER_DIRECTORY/inventory.yml"
---
swarm_manager:
  hosts:
    manager1:
      ansible_host: __PUBLIC_IP_ADDRESS_OF_SWARM_MANAGER__
      ansible_private_ip: __PRIVATE_IP_ADDRESS_OF_SWARM_MANAGER__
  vars:
    ansible_user: ubuntu
    ansible_private_key_file: ~/.ssh/__SSH_KEY_FILE__ # be sure this exists in the ${SERVER_DIRECTORY}/.ssh directory

# This section is only necessary if you are going to use 'kit provision' command to provision and configure your swarm.
#swarm_worker:
#  hosts:
#    worker1:
#      ansible_host: __PUBLIC_IP_ADDRESS_OF_SWARM_WORKER__
#    # Copy and paste for as many worker nodes that exist
#    worker2:
#      ansible_host: __PUBLIC_IP_ADDRESS_OF_SWARM_WORKER__
#  vars:
#    ansible_user: ubuntu
#    ansible_private_key_file: ~/.ssh/__SSH_KEY_FILE__

swarm:
  children:
    swarm_manager:
#    swarm_workers:

all:
  children:
    swarm:
XXX

  # create server_settings.yml
  CLOUD_PROVIDER="aws"
  cat <<XXX > "$SERVER_DIRECTORY/server_settings.yml"
---
cloud_provider: ${CLOUD_PROVIDER}

XXX

  echo_green "Deployment server '$NAME' created successfully: ${SERVER_DIRECTORY}."
}

function make_help() {
  echo_command "kit make server <NAME>" "Make a new deployment server."
}