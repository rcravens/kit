#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    run_docker_compose up -d "${ENTRY_SERVICE}"

    # If not production...ensure php application is initialized
    if [[ ! -d "${APP_DIRECTORY}/${PATH_TO_CODE}/vendor"  && $ENV == 'dev' ]]; then
        echo -e "Running composer install (missing directory: ${YELLOW}${PATH_TO_CODE}/vendor)${RESET}"
        run_docker_compose exec -it "${ENTRY_SERVICE}" php /bin/composer.phar install
        run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan key:generate
        run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan migrate --force
    fi

    # If not production...ensure node application is initialized
    if [[ ! -d "${APP_DIRECTORY}/${PATH_TO_CODE}/node_modules" && $ENV == 'dev' ]]; then
        echo -e "Running npm install & npm build (missing directory: ${YELLOW}${PATH_TO_CODE}/node_modules)${REST}"
        run_docker_compose exec -it "${ENTRY_SERVICE}" npm install
        run_docker_compose exec -it "${ENTRY_SERVICE}" npm run build
    fi
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