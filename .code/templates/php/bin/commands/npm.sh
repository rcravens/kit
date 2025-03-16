#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    run_docker_compose exec -it "${ENTRY_SERVICE}" npm $ARGS
}

function command_help() {
    echo_command "kit ${APP} npm <COMMAND>" "Run a npm command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} npm run build"
    echo_divider
}