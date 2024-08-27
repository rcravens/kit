#!/usr/bin/env bash

function command_run {
    if [ -z "$1" ] || [ "$ARG" == "help" ]; then
       command_help
       command_help_details
       exit 1
    fi

    TEMPLATE_TYPE="$1"
    export APP_NAME="$2"
    shift 2

    clear

    TEMPLATE_DIRECTORY="$TEMPLATES_DIRECTORY/$TEMPLATE_TYPE"
    if [ ! -d "$TEMPLATE_DIRECTORY" ]; then
      echo_red "The '$TEMPLATE_TYPE' template does not exist."
      command_help_details
      exit 1
    fi

    # Collect information for this template from the user
    # APP_NAME
    if [ -z "$APP_NAME" ]; then
      read -p "${GREEN}Enter the application short name [aaa]: ${BLUE}" APP_NAME
      APP_NAME="${APP_NAME:-aaa}"
    fi

    # CODE_REPO_URL
    read -p "${GREEN}Enter the Git repository URL [$TEMPLATE_TYPE default]: ${BLUE}" CODE_REPO_URL
    echo -e "${RESET}"

    # Validate the CODE_REPO_URL format
    export APP_DIRECTORY="$APPS_DIRECTORY/$APP_NAME"
#    echo "APP_NAME: $APP_NAME"
#    echo "APP_DIRECTORY: $APP_DIRECTORY"
#    echo "TEMPLATE_DIRECTORY: $TEMPLATE_DIRECTORY"
#    echo "CODE_REPO_URL: $CODE_REPO_URL"

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
      echo "An application with this name already exists. Try running the following:"
      echo_command "kit $APP_NAME start"
      exit 1
    fi

    # Call the new_init.sh script for the template
    if [ -f "$APP_DIRECTORY/bin/new_init.sh" ]; then
      export CODE_REPO_URL
     . "$APP_DIRECTORY/bin/new_init.sh"
    fi

    echo_green "Application '$APP_NAME' created successfully."

    eval "./kit ${APP_NAME} ${ENV} create"
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