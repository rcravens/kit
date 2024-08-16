#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ ! -d "${PATH_TO_CODE}/vendor/laravel/horizon" ]; then
        echo_yellow "Horizon not found...installing now"
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm composer require laravel/horizon
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm artisan horizon:install
    fi

    if [ "$1" == "start" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" up -d horizon
        URL="https://${APP_DOMAIN}:${HTTPS_ON_HOST}/horizon"
        open "${URL}"
    elif [ "$1" == "stop" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down horizon
    elif [ "$1" == "destroy" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down --rmi all -v horizon
    else
        echo "Unknown command!"
    fi
}

function command_help() {
    echo_command "kit horizon start" "Starts horizon"
    echo_command "kit horizon stop" "Stops horizon"
    echo_command "kit horizon destroy" "Stops horizon and delete associated images"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit horizon start"
    echo_divider
}