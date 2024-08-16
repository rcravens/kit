#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm npm "$@"
}

function command_help() {
    echo_command "kit npm <COMMAND>" "Run a npm command"
    echo_command "kit npx <COMMAND>" "Run a npx command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit npm run build"
    echo_divider
}