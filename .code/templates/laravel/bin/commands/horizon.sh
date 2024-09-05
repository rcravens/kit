#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ ! -d "${PATH_TO_CODE}/vendor/laravel/horizon" ]; then
        echo_yellow "Horizon not found...installing now"
        run_docker_compose exec -it "${ENTRY_SERVICE}" php /bin/composer.phar require laravel/horizon
        run_docker_compose exec -it "${ENTRY_SERVICE}" php artisan horizon:install
    fi

    if [ "$ARGS" == "start" ] || [ "$ARGS" == "up" ]; then
      run_docker_compose exec -it -d "${ENTRY_SERVICE}" php artisan horizon
      URL="https://${APP_DOMAIN}:${HTTPS_ON_HOST}/horizon"
      open "${URL}"
    elif [ "$ARGS" == "stop" ] || [ "$ARGS" == "down" ]; then
      run_docker_compose exec -it -d "${ENTRY_SERVICE}" php artisan horizon:terminate
    else
        echo "Unknown command!"
    fi
}

function command_help() {
    echo_command "kit ${APP} horizon start" "Starts horizon"
    echo_command "kit ${APP} horizon stop" "Stops horizon"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} horizon start"
    echo_divider
}