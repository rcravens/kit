#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ "$1" == "start" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" up -d cron
    elif [ "$1" == "stop" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down cron
    elif [ "$1" == "destroy" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down --rmi all -v cron
    else
        echo "Unknown command!"
    fi
}

function command_help() {
    echo_command "kit ${APP} cron start" "Starts horizon"
    echo_command "kit ${APP} cron stop" "Stops horizon"
    echo_command "kit ${APP} cron destroy" "Stops horizon and delete associated images"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} cron start"
    echo_divider
}