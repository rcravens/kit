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
swarm_worker:
  hosts:
    worker1:
      ansible_host: __IP_ADDRESS_OF_SWARM_WORKER__
    # Copy and paste for as many worker nodes that exist
    worker2:
      ansible_host: __IP_ADDRESS_OF_SWARM_WORKER__
  vars:
    ansible_user: ubuntu
    ansible_private_key_file: ~/.ssh/__SSH_KEY_FILE__

swarm:
  children:
    swarm_manager:
    swarm_workers:

all:
  children:
    swarm:
  vars:
    # The following four lines support ansible accessing swarm nodes that are provisioned in a private subnet
    #   by using a jump box or a bastion server. If the nodes are public accessible, just comment these lines
    #   and supply the public IP addresses at the top for direct connections.
    jump_box_host: 100.26.108.96
    jump_box_user: ubuntu
    jump_box_key_file: ~/.ssh/laravel_demo.pem
    ansible_ssh_common_args: "-o ProxyCommand='ssh -i {{jump_box_key_file}} -W %h:%p -q {{jump_box_user}}@{{jump_box_host}}'"
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