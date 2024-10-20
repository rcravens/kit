#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    CMD_LINE=$*

#    echo "ARGS: $ARGS"
#    echo "SERVER: $SERVER"
#    echo "CMD_LINE: $CMD_LINE"
#    echo "ENTRY_SERVICE: $ENTRY_SERVICE"

    if [ -z "$SERVER_DIRECTORY" ]; then
      echo "No server specified, running on default server: ${BLUE}development${RESET}"
      run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan "${CMD_LINE}"
    else
      eval "./kit ${APP}:${SERVER} run php artisan ${CMD_LINE}"
    fi
}

function command_help() {
    echo_command "kit ${APP}<:srv> artisan <COMMAND>" "Run an Artisan command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} artisan queue:work" "Runs the ${BLUE}queue:work${RESET} artisan command in ${RED}development${RESET}"
    echo_example "kit ${APP}:<srv> artisan queue:work" "Runs the ${BLUE}queue:work${RESET} artisan command on the ${RED}<srv>${RESET} servers"
    echo_divider
    echo_green "‼️ To display the artisan help screen run ‼️"
    echo_example "kit ${APP} artisan"
    echo
}