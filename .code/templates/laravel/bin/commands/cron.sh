#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$SERVER_DIRECTORY" ]; then
      echo "No server specified, running on default server: ${BLUE}development${RESET}"
      if [ "$1" == "start" ] || [ "$1" == "up" ]; then
        run_docker_compose exec -it -d "${ENTRY_SERVICE}" php artisan schedule:work
      elif [ "$1" == "stop" ] || [ "$1" == "down" ]; then
        run_docker_compose exec -it -d "${ENTRY_SERVICE}" /bin/sh -c "kill \$(ps aux | grep '[s]chedule:work' | awk '{print \$1}' )"
      else
          echo "Unknown command!"
      fi
    else
      eval "./kit ${APP}:${SERVER} run \"crond -f &\""
    fi
}

function command_help() {
    echo_command "kit ${APP} cron start" "Starts horizon"
    echo_command "kit ${APP} cron stop" "Stops horizon"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} cron start"
    echo_divider
}