#!/usr/bin/env bash

# Define color codes
BOLD=$(printf '\033[1m')
YELLOW=$(printf '\033[0;33m')
GREEN=$(printf '\033[0;32m')
BLUE=$(printf '\033[0;34m')
RED=$(printf '\033[0;31m')
MAGENTA=$(printf '\033[1;35m')
RESET=$(printf '\033[0m')

# Function to echo text in bold
function echo_bold {
    echo -e "${BOLD}$1${RESET}"
}

# Function to echo text in yellow
function echo_yellow {
    echo -e "${YELLOW}$1${RESET}"
}

# Function to echo text in green
function echo_green {
    echo -e "${GREEN}$1${RESET}"
}

# Function to echo text in blue
function echo_blue {
    echo -e "${BLUE}$1${RESET}"
}

# Function to echo text in red
function echo_red {
    echo -e "${RED}$1${RESET}"
}

# Function to echo text in magenta
function echo_magenta {
    echo -e "${MAGENTA}$1${RESET}"
}

function echo_divider {
    echo "-----------------------------------------------------------------------------------"
}

# Function to echo out a command line with aligned descriptions
function echo_command {
    local command="$1"
    local indent="  "
    if [ ! -z "$2" ]; then
      local description="$2"
      local num_command_chars=${#command}
      local total_command_length=35
      local num_spaces=`expr $total_command_length - $num_command_chars`
      local gap=`printf '%*s' "$num_spaces" | tr ' ' " "`

      echo -e "${indent}${GREEN}$command${RESET}${gap}${description}"
    else
      echo -e "${indent}${GREEN}$command${RESET}"
    fi
}

# Function to echo out an example
function echo_example {
    local example="$1"
    local indent="  👉 "
    if [ ! -z "$2" ]; then
      local description="$2"
      local num_command_chars=${#example}
      local total_command_length=32
      local num_spaces=`expr $total_command_length - $num_command_chars`
      local gap=`printf '%*s' "$num_spaces" | tr ' ' " "`
      echo -e "${indent}${BLUE}$example${RESET}${gap}${description}"
    else
      echo -e "${indent}${BLUE}$example${RESET}"
    fi
}