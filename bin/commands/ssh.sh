#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}"  exec -it "$@" /bin/sh
}

function command_help() {
    echo_command "kit ssh <SERVICE>" "Opens shell access to container"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ssh nginx"
    echo_example "kit ssh php"
    echo_divider
}