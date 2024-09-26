#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "${ENTRY_SERVICE}" ]; then
      echo "xxx"
      echo "ENTRY_SERVICE: ${ENTRY_SERVICE}"
      echo "ARGS: ${ARGS}"
    else
      run_docker_compose  exec -it "${ENTRY_SERVICE}" /bin/sh
    fi

}

function command_help() {
    echo_command "kit <app> ssh" "Opens shell access to the application container"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel ssh" "Opens shell access to the ${RED}laravel${RESET} application."
    echo_divider
}