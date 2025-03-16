#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    # If not production...ensure php application is initialized
    echo -e "Running composer install"
    run_docker_compose exec -it "${ENTRY_SERVICE}" php /bin/composer.phar install

    # If not production...ensure node application is initialized
    echo -e "Running npm install & npm build"
    run_docker_compose exec -it "${ENTRY_SERVICE}" npm install
    run_docker_compose exec -it "${ENTRY_SERVICE}" npm run build
}

function command_help() {
    echo_command "kit ${APP} build" "Build the PHP application."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} build" "Builds the PHP application by running ${BLUE}composer install${RESET}, ${RED}npm install${RESET}, and ${RED}npm run build${RESET}."
    echo_divider
    echo
}