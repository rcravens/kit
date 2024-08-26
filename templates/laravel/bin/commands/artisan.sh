#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi
echo "xyz"
    run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan $ARGS
}

function command_help() {
    echo_command "kit ${APP} artisan <COMMAND>" "Run an Artisan command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} artisan queue:work" "Runs the ${BLUE}queue:work${RESET} artisan command in ${RED}development${RESET}"
    echo_divider
    echo_green "‼️ To display the artisan help screen run ‼️"
    echo_example "kit ${APP} artisan"
    echo
}