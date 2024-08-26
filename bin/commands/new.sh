#!/usr/bin/env bash

function command_run {
    if [ "$ARG" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    TEMPLATE_TYPE="$1"
    APP_NAME="$2"
    shift 2

    case "$TEMPLATE_TYPE" in
      "laravel" )
        TEMPLATE_REPO="https://github.com/rcravens/kit-laravel-template"
        ;;
      *)
        echo_red "Unsupported template type: $TEMPLATE_TYPE"
        command_help
        return 1
        ;;
    esac

    APP_DIRECTORY="$APPS_DIRECTORY/$APP_NAME"
    echo "APP_DIRECTORY: $APP_DIRECTORY"
    echo "TEMPLATE_REPO: $TEMPLATE_REPO"
    echo "TEMPLATE_TYPE: $TEMPLATE_TYPE"

    if [ -n "$1" ]; then
        if [ "$1" == "force" ] || [ "$1" == "-f" ] || [ "$1" == "-force" ] || [ "$1" == "--force" ]; then
            echo_red "Deleting apps directory: ${APP_DIRECTORY}"
            rm -rf "${APP_DIRECTORY}"
        fi
    fi

    if [ ! -d "$APP_DIRECTORY" ]; then
      git clone -b master --depth 1 --single-branch $TEMPLATE_REPO "$APP_DIRECTORY"
      rm -rf "$APP_DIRECTORY/.git"
    else
      echo "An application with this name already exists."
    fi
}

function command_help() {
  echo_command "kit new [TEMPLATE] [APP NAME]" "Creates a new application from a template"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit new laravel [APP NAME]" "Creates a new Laravel application."
    echo_divider
}