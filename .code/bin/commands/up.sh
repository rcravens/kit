#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    eval "./kit ${APP} start ${ARGS}"
}

function command_help() {
  echo_command "kit <app> up" "Same as kit start...starts the application."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel up" "Starts the ${RED}laravel${RESET} application"
    echo_divider
}