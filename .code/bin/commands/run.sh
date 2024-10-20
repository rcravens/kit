#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    CMD_LINE=$*

    if [ -z "$SERVER" ] || [ ! -d "$SERVER_DIRECTORY" ]; then
      echo "Unexpected server: $SERVER"
      echo_example "kit [app:srv] run [cmd]"
      exit 1
    fi

    IMAGE_REPO="${REGISTRY_URL}/${REGISTRY_REPO}:${REGISTRY_DEPLOYED_VERSION}"
    RUN_CMD_FILE="${APP_DIRECTORY}/run_cmd.yml"
    echo "---" > "$RUN_CMD_FILE"
    echo "image: \"${IMAGE_REPO}\"" >> "$RUN_CMD_FILE"
    echo "command: \"$CMD_LINE\"" >> "$RUN_CMD_FILE"

    echo "APP: $APP"
    echo "SERVER: $SERVER"
    echo "CMD_LINE: $CMD_LINE"
    echo "IMAGE_REPO: $IMAGE_REPO"
    echo "RUN_CMD_FILE: ${RUN_CMD_FILE}"

    run_ansible "$SERVER" \
      -v "$RUN_CMD_FILE":/ansible/run_cmd.yml \
      playbooks/run_cmd.yml
}

function command_help() {
  echo_command "kit <app:srv> run <cmd>" "Run a command inside a new container for our application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel:prod run php artisan migrate" "Run ${RED}php artisan migrate${RESET} in the ${RED}laravel${RESET} application container on the ${RED}prod${RESET} server"
    echo_divider
}