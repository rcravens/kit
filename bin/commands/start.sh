#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

#    echo "bin/commands/start.sh"
#    echo "PATH_TO_CODE: $PATH_TO_CODE"
#    echo "ENTRY_SERVICE: $ENTRY_SERVICE"
#    echo "ARGS: $ARGS"
#    ls -la $PATH_TO_CODE
#    read -p "Pausing for user <ENTER>:" xxx

    run_docker_compose up -d "${ENTRY_SERVICE}"
}

function command_help() {
  echo_command "kit start" "Start the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit start"
    echo_divider
}