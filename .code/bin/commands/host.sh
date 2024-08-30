#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       exit 1
    fi

    echo "${APP_DOMAIN}"

    # Ensure host file has entry for this app
    if [ -f "/etc/hosts" ]; then
        echo_yellow "Ensuring domain exists in host file"
        matches_in_hosts="$(grep -n "${APP_DOMAIN}" /etc/hosts | cut -f1 -d:)"
        if [ -n "${matches_in_hosts}" ]; then
            echo_blue "Domain exists already"
        else
            sudo -- sh -c -e "echo '127.0.0.1       ${APP_DOMAIN}' >> /etc/hosts"
            echo_blue "Domain added"
        fi
    else
        echo_red "Host file not found at /etc/hosts. You may need to add the domain manually."
    fi
}

function command_help() {
  echo_command "kit host" "Ensure host_name exists in local hosts file."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit [app] [env] host" "Ensures ${RED}APP_DOMAIN${RESET} exists in the local hosts file for the application."
    echo_divider
}
