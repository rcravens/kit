#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm artisan "$@"
}

function command_help() {
    echo_command "kit artisan <COMMAND>" "Run an Artisan command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit artisan queue:work" "Runs the ${BLUE}queue:work${RESET} artisan command in ${RED}development${RESET}"
    echo_divider
    echo_green "‼️ To display the artisan help screen run ‼️"
    echo_example "kit artisan"
    echo
}