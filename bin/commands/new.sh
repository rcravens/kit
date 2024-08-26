#!/usr/bin/env bash

function command_run {
    if [ -z "$1" ] || [ "$ARG" == "help" ]; then
       command_help
       command_help_details
       exit 1
    fi

    TEMPLATE_TYPE="$1"
    APP_NAME="$2"
    shift 2

    TEMPLATE_DIRECTORY="$TEMPLATES_DIRECTORY/$TEMPLATE_TYPE"
    if [ ! -d "$TEMPLATE_DIRECTORY" ]; then
      echo_red "The '$TEMPLATE_TYPE' template does not exist."
      command_help_details
      exit 1
    fi

    APP_DIRECTORY="$APPS_DIRECTORY/$APP_NAME"
    echo "APP_DIRECTORY: $APP_DIRECTORY"
    echo "TEMPLATE_DIRECTORY: $TEMPLATE_DIRECTORY"

    # Force delete the existing application from the apps directory
    if [ -n "$1" ]; then
        if [ "$1" == "force" ] || [ "$1" == "-f" ] || [ "$1" == "-force" ] || [ "$1" == "--force" ]; then
            echo_red "Deleting apps directory: ${APP_DIRECTORY}"
            rm -rf "${APP_DIRECTORY}"
        fi
    fi

    # Create the new application from the template
    if [ ! -d "$APP_DIRECTORY" ]; then
      cp -a "$TEMPLATE_DIRECTORY" "$APP_DIRECTORY"
    else
      echo "An application with this name already exists."
    fi


}

function command_help() {
  echo_command "kit new [TEMPLATE] [APP NAME]" "Creates a new application from a template"
}

function command_help_details() {
    echo_divider
    echo "Available Templates:"
    for TEMP_DIR in $TEMPLATES_DIRECTORY/*
    do
      TEMPLATE=$(basename "$TEMP_DIR")
      echo_example "kit new $TEMPLATE [APP NAME]"
    done
    echo_divider
}