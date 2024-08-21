#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi
    echo_red "Coming Soon"

#    if [ "$1" == "app" ]; then
#        TEMPLATE_FILE="${COMPOSE_FILE}"
#        STACK_FILE="${ANSIBLE_DIRECTORY}/playbooks/swarm/stacks/app.yml"
#    elif [ "$1" == "viz" ]; then
#        TEMPLATE_FILE="${ANSIBLE_DIRECTORY}/playbooks/swarm/stacks/templates/visualizer.yml"
#        STACK_FILE="${ANSIBLE_DIRECTORY}/playbooks/swarm/stacks/visualizer.yml"
#    elif [ "$1" == "mysql" ]; then
#        TEMPLATE_FILE="${ANSIBLE_DIRECTORY}/playbooks/swarm/stacks/templates/mysql.yml"
#        STACK_FILE="${ANSIBLE_DIRECTORY}/playbooks/swarm/stacks/mysql.yml"
#    else
#        echo "Unknown stack!"
#        return 1
#    fi
#
#    echo "ROOT_DIRECTORY: ${ROOT_DIRECTORY}"
#    echo "ANSIBLE_DIRECTORY: ${ANSIBLE_DIRECTORY}"
#    echo "TEMPLATE_FILE: ${TEMPLATE_FILE}"
#    echo "STACK_FILE: ${STACK_FILE}"
#
#    envsubst < "${TEMPLATE_FILE}" > "${STACK_FILE}"
#
#    sed -i '' '/platform: linux\/amd64/d' "${STACK_FILE}"
#
#    docker run --rm --pull=always -it \
#      -v "$ROOT_DIRECTORY/deploy.yml":/ansible/settings.yml \
#      -v ~/.ssh:/root/.ssh \
#      -v ~/.aws:/root/.aws \
#      rcravens/ansible ansible-playbook playbooks/deploy.yml
}

function command_help() {
  echo_command "kit deploy" "Deploy application to Docker Swarm in AWS"
}

function command_help_details() {
    echo_divider
    echo_red "Before running this command be sure to copy 'deploy-example.yml' to 'deploy.yml' and update deployment data."
    echo "Examples:"
    echo_example "kit deploy"
    echo_divider
}