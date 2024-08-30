#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ "$ENV" == "dev" ]; then
      # If not production...ensure php application is initialized
      echo -e "Running pip install"
      run_docker_compose exec -it "${ENTRY_SERVICE}" pip install --no-cache-dir -r requirements.txt
    fi
}

function command_help() {
    echo_command "kit ${APP} build" "Build the Django application."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} build" "Builds the Django application by running ${BLUE}pip install${RESET}."
    echo_divider
    echo
}