#!/usr/bin/env bash

function make_run {
  if [ "$ARGS" == "help" ]; then
     make_help
     return 1
  fi

  NAME=$1

  COMMAND_FILE="${APP_DIRECTORY}/bin/commands/${NAME}.sh"
  if [ -f "$COMMAND_FILE" ]; then
    echo_red "This command already exists. Choose a different name."
    exit 1
  fi

  cat <<XXX >> "$COMMAND_FILE"
#!/usr/bin/env bash

function command_run {
    if [ "\$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    # PUT YOUR COMMAND LOGIC HERE
}

function command_help() {
    echo_command "kit ${APP} ${NAME}" "___DESCRIBE_YOUR_COMMAND___"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit ${APP} ${NAME}" "___PROVIDE_A_DETAILED_EXAMPLE___"
    echo
}
XXX

}

function make_help() {
  echo_command "kit <APP> make command <NAME>" "Make a new command for an application."
}