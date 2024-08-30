#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    # Do your work here
    echo "Do your work here!"
}

function command_help() {
    echo_command "kit ${APP} example <COMMAND>" "This is an example command."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} example work" "Runs the ${BLUE}work${RESET}  command in ${RED}development${RESET}"
    echo
}