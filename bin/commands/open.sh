#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    URL="https://${APP_DOMAIN}:${HTTPS_ON_HOST}"
    open "${URL}"
}

function command_help() {
  echo_command "kit open" "Opens browser tab to application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit open"
    echo_divider
}