#!/usr/bin/env bash

function display_banner {
    echo_blue "   ___  ____    _____   _________  "
    echo_blue "  |_  ||_  _|  |_   _| |  _   _  | "
    echo_blue "    | |_/ /      | |   |_/ | | \_| "
    echo_blue "    |  __'.      | |       | |     "
    echo_blue "   _| |  \ \_   _| |_     _| |_    "
    echo_blue "  |____||____| |_____|   |_____|   "
    echo_blue "                                   "
  }

  function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    display_banner
    echo -e "${BOLD}🚀 Laravel Starter Kit 🚀${RESET}"
    echo
    echo_yellow "Usage:"
    echo "  kit [app] [env] COMMAND [options] [arguments]"
    echo
    echo "examples:"
    echo_example "kit build" "Build the application"
    echo_example "kit prod build" "Build the production version of the application"
    echo_example "kit abc prod build" "Build the production version of the abc application"
    echo

    echo_yellow "💥 Command List:"
    for COMMAND_FILE in $BIN_DIRECTORY/commands/*
    do
      source "$COMMAND_FILE"
      command_help
    done

    echo_divider
    echo -e "${BOLD} 👉 Application Specific Commands ${RESET}"
    for APP_DIR in $APPS_DIRECTORY/*
    do
      APP=$(basename "$APP_DIR")
      echo "Application Specific Commands: $APP"
      echo_example "kit $APP [env] [command] [args]"
      for COMMAND_FILE in $APP_DIR/bin/commands/*
      do
        source "$COMMAND_FILE"
        command_help
      done
      echo_divider
    done

    echo
    exit 1
}

function command_help() {
  echo_command "kit help" "List all the commands"
  echo_command "kit <COMMAND> help" "Detailed help for a specific command"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit help"
    echo_example "kit artisan help"
    echo_divider
}