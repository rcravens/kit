#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$SERVER_DIRECTORY" ]; then
      echo "No server specified, running on default server: ${BLUE}development${RESET}"
      run_docker_compose exec -it web php artisan migrate
    else
      eval "./kit ${APP}:${SERVER} run \"php artisan migrate\""
    fi
}

function command_help() {
  echo_command "kit ${APP} migrate" "Runs database migrations"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} migrate"
    echo_divider
}