#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    echo "APP: $APP"
    echo "SERVER: $SERVER"
    if [ -z "${ENTRY_SERVICE}" ]; then
      DESTINATION_BOX_IP="$2"

      INVENTORY_FILE="$SERVERS_DIRECTORY/$SERVER/inventory.yml"
#      echo $(parse_yaml "$INVENTORY_FILE")
      eval $(parse_yaml "$INVENTORY_FILE")
      JUMP_BOX_IP="${all_vars_jumpbox_host}"
      JUMP_BOX_USER="${all_vars_jumpbox_user}"
      JUMP_BOX_IDENT="${all_vars_jumpbox_key_file}"
      JUMP_BOX_IDENT=$(echo "$JUMP_BOX_IDENT" | sed -r "s|~|${SERVERS_DIRECTORY}/${SERVER}|")
      if [ -z "${DESTINATION_BOX_IP}" ]; then
        DESTINATION_BOX_IP="${swarm_manager_hosts___ansible_private_ip}"
      fi
      DESTINATION_BOX_USER="${swarm_manager_vars_ansible_user}"
      DESTINATION_BOX_IDENT="${swarm_manager_vars_ansible_private_key_file}"
      DESTINATION_BOX_IDENT=$(echo "$DESTINATION_BOX_IDENT" | sed -r "s|~|${SERVERS_DIRECTORY}/${SERVER}|")
      echo "JUMP_BOX_IP: ${JUMP_BOX_IP}"
      echo "JUMP_BOX_USER: ${JUMP_BOX_USER}"
      echo "JUMP_BOX_IDENT: ${JUMP_BOX_IDENT}"
      echo "DESTINATION_BOX_IP: ${DESTINATION_BOX_IP}"
      echo "DESTINATION_BOX_USER: ${DESTINATION_BOX_USER}"
      echo "DESTINATION_BOX_IDENT: ${DESTINATION_BOX_IDENT}"

      ssh -o ProxyCommand="ssh -W %h:%p -i ${JUMP_BOX_IDENT} ${JUMP_BOX_USER}@${JUMP_BOX_IP}" -i "${DESTINATION_BOX_IDENT}" "${DESTINATION_BOX_USER}@${DESTINATION_BOX_IP}"
    else
      run_docker_compose  exec -it "${ENTRY_SERVICE}" /bin/sh
    fi

}

function command_help() {
    echo_command "kit <app:srv> ssh <ip>" "Opens shell access to the application container"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel ssh" "Opens shell access to the ${RED}laravel${RESET} application."
    echo_example "kit :prod ssh" "Opens shell access to the ${RED}prod${RESET} server."
    echo_divider
}