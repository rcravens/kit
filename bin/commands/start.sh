#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" up -d "${ENTRY_SERVICE}"

    # If not production...ensure php application is initialized
    if [[ ! -d "${PATH_TO_CODE}/vendor"  && ! "${IS_PROD}" ]]; then
        echo -e "Running composer install (missing directory: ${YELLOW}${PATH_TO_CODE}/vendor)${RESET}"
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm composer install
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm artisan key:generate
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm artisan migrate --force
    fi

    # If not production...ensure node application is initialized
    if [[ ! -d "${PATH_TO_CODE}/node_modules" && ! "${IS_PROD}" ]]; then
        echo -e "Running npm install & npm build (missing directory: ${YELLOW}${PATH_TO_CODE}/node_modules)${REST}"
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm npm install
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm npm run build
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