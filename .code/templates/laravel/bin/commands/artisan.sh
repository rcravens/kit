#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    SERVER=$1
    shift 1
    CMD_LINE=$*

    SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${SERVER}"
    if [ -z "$SERVER" ] || [ ! -d "$SERVER_DIRECTORY" ]; then
      # This is not a server....prepend this back into the CMD_LINE
      CMD_LINE="$SERVER $CMD_LINE"
      SERVER=""
    fi

    echo "ARGS: $ARGS"
    echo "SERVER: $SERVER"
    echo "CMD_LINE: $CMD_LINE"
    echo "ENTRY_SERVICE: $ENTRY_SERVICE"

    if [ -z "$SERVER" ]; then
      echo "No server specified, running on default server: ${BLUE}development${RESET}"
      run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan "${CMD_LINE}"
    else
       eval "./kit ${APP} run ${SERVER} php artisan ${CMD_LINE}"
    fi
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