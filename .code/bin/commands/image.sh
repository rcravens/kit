#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$ARGS" ]; then
        run_docker_compose build --build-arg CACHE_DATE="$(date)" "${ENTRY_SERVICE}"
    else
        run_docker_compose build --build-arg CACHE_DATE="$(date)" $ARGS
    fi
}

function command_help() {
  echo_command "kit <app> image" "Build the Docker image for this application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel image" "Builds the ${RED}production${RESET} Docker images for the ${RED}laravel${RESET} application"
    echo_divider
}