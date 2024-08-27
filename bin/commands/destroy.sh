#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    echo_red "This action cannot be undone!!!"
    echo_red "You are about to delete the ${APP} app along with the local docker images, and code."
    read -r -p "Are you sure? [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY])
            run_docker_compose down --rmi all -v --remove-orphans
            if [ -d "$APP_DIRECTORY" ]; then
              rm -rf "$APP_DIRECTORY";
            fi
            if [ -d "$PATH_TO_CODE" ]; then
              rm -rf "$PATH_TO_CODE";
            fi
            echo_green "The ${APP} app and related files have been successfully deleted."
            ;;
        *)
           echo_red "Operation cancelled."
           exit 1
           ;;
    esac
}

function command_help() {
  echo_command "kit destroy" "Stop the application and delete all images"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit destroy"
    echo_divider
}