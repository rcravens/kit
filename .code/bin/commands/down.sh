#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    eval "./kit ${APP} stop ${ARGS}"
}

function command_help() {
  echo_command "kit <app> down" "Same as kit <app> stop"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel down" "Stops the ${RED}laravel${RESET} application."
    echo_divider
}