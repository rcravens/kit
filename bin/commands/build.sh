#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$ARGS" ]; then
        run_docker_compose build "${ENTRY_SERVICE}"
    else
        run_docker_compose build $ARGS
    fi
}

function command_help() {
  echo_command "kit build" "Build the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit build" "Builds the ${RED}development${RESET} Docker images"
    echo_example "kit build php" "Builds the ${RED}development${RESET} Docker image for the ${BLUE}php${RESET} service"
    echo_example "kit prod build" "Builds the ${RED}production${RESET} Docker images"
    echo_divider
}