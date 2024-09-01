#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    echo "coming soon...."
    exit 1

#    docker run --rm --pull=always -it \
#      -v "$ROOT_DIRECTORY/deploy.yml":/ansible/settings.yml \
#      -v ~/.ssh:/root/.ssh:rw \
#      -v ~/.aws:/root/.aws \
#      rcravens/ansible ansible-playbook playbooks/teardown.yml
}

function command_help() {
  echo_command "kit teardown <dest>" "Shutdown and delete the nodes for this server."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit teardown <dest>"
    echo_divider
}