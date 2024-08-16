#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

   docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm composer "$@"
}

function command_help() {
  echo_command "kit composer <COMMAND>" "Run a composer command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit composer require laravel/sanctum" "Runs ${BLUE}composer require laravel/sanctum${RESET} in ${RED}development${RESET}"
    echo_divider
}