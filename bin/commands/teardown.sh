#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker run --rm --pull=always -it \
      -v "$ROOT_DIRECTORY/deploy.yml":/ansible/settings.yml \
      -v ~/.ssh:/root/.ssh:rw \
      -v ~/.aws:/root/.aws \
      rcravens/ansible ansible-playbook playbooks/teardown.yml
}

function command_help() {
  echo_command "kit teardown" "Teardown Docker Swarm in AWS"
}

function command_help_details() {
    echo_divider
    echo_red "Before running this command be sure to copy 'deploy-example.yml' to 'deploy.yml' and update deployment data."
    echo "Examples:"
    echo_example "kit teardown"
    echo_divider
}