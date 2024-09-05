#!/usr/bin/env bash

function make_run {
  if [ "$ARGS" == "help" ]; then
     make_help
     return 1
  fi

  NAME=$1
   if [ -z "$NAME" ]; then
    echo_red "Please provide a environment name."
    exit 1
  fi

  DEST_DIR="${APP_DIRECTORY}/envs/${NAME}"
  if [ -d "$DEST_DIR" ]; then
    echo_red "This environment already exists. Choose a different name."
    exit 1
  fi

  SOURCE_DIR="${APP_DIRECTORY}/envs/dev"
  if [ ! -d "$SOURCE_DIR" ]; then
    echo_red "There is no ${SOURCE_DIR} that can be copied."
    exit 1
  fi

  cp -a "$SOURCE_DIR" "$DEST_DIR"

  echo_green "Created a new environment called '$NAME' you can modify settings here: ${DEST_DIR}."
}

function make_help() {
  echo_command "kit make server <NAME>" "Make a new deployment server."
}