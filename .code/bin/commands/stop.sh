#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    run_docker_compose down
}

function command_help() {
  echo_command "kit stop" "Stop the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit stop"
    echo_divider
}