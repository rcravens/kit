#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    eval "./kit ${APP} ${ENV} stop ${ARGS}"
}

function command_help() {
  echo_command "kit down" "Same as kit stop"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit down"
    echo_divider
}