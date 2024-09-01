#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    echo "HTTPS_ON_HOST: ${HTTPS_ON_HOST}"
    echo "HTTP_ON_HOST: ${HTTP_ON_HOST}"

    if [ -n "${HTTPS_ON_HOST}" ]; then
      URL="https://${APP_DOMAIN}:${HTTPS_ON_HOST}"
    else
      URL="http://${APP_DOMAIN}:${HTTP_ON_HOST}"
    fi
    open "${URL}"
}

function command_help() {
  echo_command "kit <app> open" "Opens browser tab to application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel open" "Opens a browser tab for the ${RED}laravel${RESET} application"
    echo_divider
}