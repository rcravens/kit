#!/usr/bin/env bash

function command_run {
  if [ "$ARGS" == "help" ]; then
     command_help
     command_help_details
     return 1
  fi
  # kit [app] make [obj]
  OBJ=$1
  shift 1
  ARGS=$@

  MAKE_FILE="${BIN_DIRECTORY}/makers/${OBJ}.sh"
  if [ -f "$MAKE_FILE" ]; then
    source "$MAKE_FILE"
    # shellcheck disable=SC2086
    make_run $ARGS
  else
    command_help
    command_help_details
    return 1
  fi
}

function command_help() {
  echo_command "kit make help" "List all the make commands"
  echo_command "kit <app> make <obj>" "Create a new features for the application"
}

function command_help_details() {
  echo_divider
  echo_yellow "💥 Available make commands:"
  for COMMAND_FILE in $BIN_DIRECTORY/makers/*.sh
  do
    source "$COMMAND_FILE"
    make_help
  done
  echo_divider
}