#!/usr/bin/env bash

function display_banner {
    printf "%s   ___  %s____    %s_____   %s_________  %s\n"      $RAINBOW $RESET
    printf "%s  |_  ||%s_  _|  |%s_   _| |%s  _   _  | %s\n"      $RAINBOW $RESET
    printf "%s    | |_%s/ /     %s | |   |%s_/ | | \_| %s\n"      $RAINBOW $RESET
    printf "%s    |  _%s_'.     %s | |    %s   | |     %s\n"      $RAINBOW $RESET
    printf "%s   _| | %s \ \_   %s_| |_   %s  _| |_    %s\n"      $RAINBOW $RESET
    printf "%s  |____|%s|____| |%s_____|  %s |_____|   %s\n"      $RAINBOW $RESET
    printf "%s        %s        %s        %s           %s\n"      $RAINBOW $RESET
    echo
  }

  function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    display_banner
    echo -e "${BOLD}🚀 Laravel Starter Kit 🚀${RESET}"
    echo
    echo_yellow "Usage:"
    echo "  kit [prod] COMMAND [options] [arguments]"
    echo
    echo "examples:"
    echo_example "kit build" "Build the application"
    echo_example "kit prod build" "Build the production version of the application"
    echo

    echo_yellow "💥 Command List:"
    for COMMAND_FILE in $BIN_DIRECTORY/commands/*
    do
      source "$COMMAND_FILE"
      command_help
    done

#    echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#
#    GENERAL_COMMANDS=('create' 'build' 'start' 'open' 'migrate' 'stop' 'restart' 'destroy' 'horizon' 'cron' 'ssh' 'ps')
#    for COMMAND in "${GENERAL_COMMANDS[@]}";
#    do
#      COMMAND_FILE="$BIN_DIRECTORY/commands/$COMMAND.sh"
#      source "$COMMAND_FILE"
#      CMD="${COMMAND}_help"
#      eval "$CMD"
#      #echo_command "kit ${COMMAND}" "${HELP}"
#    done
#
#    OTHER_COMMANDS=('artisan' 'composer' 'npm')
#    for COMMAND in "${OTHER_COMMANDS[@]}";
#    do
#      CAP_COMMAND=$(capitalize "$COMMAND")
#      echo
#      echo_yellow "💥 ${CAP_COMMAND} Commands:"
#      COMMAND_FILE="$BIN_DIRECTORY/commands/$COMMAND.sh"
#      source "$COMMAND_FILE"
#      HELP="${COMMAND}_help"
#      eval "$HELP"
#      EXAMPLES="${COMMAND}_example"
#      eval "$EXAMPLES"
#    done
#
#    echo_yellow "💥 Docker Container Registry Commands:"
#    COMMAND_FILE="$BIN_DIRECTORY/commands/$COMMAND.sh"
#    source "$COMMAND_FILE"
#    HELP="${COMMAND}_help"
#    eval "$HELP"
#    EXAMPLES="${COMMAND}_example"
#    eval "$EXAMPLES"
#    echo_command "kit push <TAG>" "Push an image to the registry"
#    echo_example "kit prod push"
#    echo_example "kit prod push v1.1"

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