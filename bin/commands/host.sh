#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       exit 1
    fi

    if [ -z "$1" ]; then
      echo_red "Missing host_name"
      command_help
      command_help_details
      exit 1
    fi

    host_name="$1"

    # Ensure host file has entry for this app
    if [ -f "/etc/hosts" ]; then
        echo_yellow "Ensuring domain exists in host file"
        matches_in_hosts="$(grep -n "${host_name}" /etc/hosts | cut -f1 -d:)"
        if [ -n "${matches_in_hosts}" ]; then
            echo_blue "Domain exists already"
        else
            sudo -- sh -c -e "echo '127.0.0.1       ${host_name}' >> /etc/hosts"
            echo_blue "Domain added"
        fi
    else
        echo_red "Host file not found at /etc/hosts. You may need to add the domain manually."
    fi
}

function command_help() {
  echo_command "kit host [host_name]" "Ensure host_name exists in local hosts file."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit host app1_dev" "Ensures ${RED}app1_dev${RESET} exists in the local hosts file."
    echo_divider
}
