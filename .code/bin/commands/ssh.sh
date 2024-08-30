#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    run_docker_compose  exec -it "${ENTRY_SERVICE}" /bin/sh
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