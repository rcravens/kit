#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$SERVER" ] || [ ! -d "$SERVER_DIRECTORY" ]; then
      echo "Unexpected server: $SERVER"
      echo_example "kit [app:server] deploy"
      exit 1
    fi

    if [ -f "${CODE_DIRECTORY}/stacks/${APP}.yml" ]; then
      # Deploying a stack file
      STACK_FILE="${CODE_DIRECTORY}/stacks/${APP}.yml"
      DEPLOY_SETTINGS_FILE="${CODE_DIRECTORY}/stacks/deploy_settings.yml"
    else
      # Deploying an application, regenerate the stack file
      STACK_FILE="${APP_DIRECTORY}/deploy_stack.yml"
      DEPLOY_SETTINGS_FILE="${APP_DIRECTORY}/deploy_settings.yml"
      rm -rf "${STACK_FILE}"
      if [ ! -f "${STACK_FILE}" ]; then
        run_docker_compose config -o "${STACK_FILE}"

        # Delete the first line of the resulting file (name: XXX)
        tail -n +2 "${STACK_FILE}" > "${STACK_FILE}.tmp" && mv "${STACK_FILE}.tmp" "${STACK_FILE}"

        # Delete lines that are not allows or fix formatting
        sed -i.bak "/platform: linux\/amd64/d" "${STACK_FILE}"
#        sed -i.bak "/name: laravel/d" "${STACK_FILE}"
        sed -i.bak "s|published: \"${HTTP_ON_HOST}\"|published: ${HTTP_ON_HOST}|" "${STACK_FILE}"
        sed -i.bak "s|published: \"${HTTPS_ON_HOST}\"|published: ${HTTPS_ON_HOST}|" "${STACK_FILE}"
        sed -i.bak "s|published: \"${MYSQL_ON_HOST}\"|published: ${MYSQL_ON_HOST}|g" "${STACK_FILE}"
        sed -i.bak "s|published: \"${REDIS_ON_HOST}\"|published: ${REDIS_ON_HOST}|g" "${STACK_FILE}"
        rm -rf "${STACK_FILE}.bak"
      fi
    fi

    echo "DEPLOY_SETTINGS_FILE: ${DEPLOY_SETTINGS_FILE}"
    echo "SERVER: ${SERVER}"
    echo "STACK_FILE: ${STACK_FILE}"

    if [ ! -f "$STACK_FILE" ]; then
      echo_red "Deploy stack file not found: ${STACK_FILE}"
      exit 1
    fi

    if [ ! -f "$DEPLOY_SETTINGS_FILE" ]; then
      echo_red "Deploy settings file not found: ${DEPLOY_SETTINGS_FILE}"
      exit 1
    fi

#    docker run --rm --pull=always -it \
#      -v "$INVENTORY_FILE":/ansible/inventory.yml \
#      -v "$SERVER_SETTINGS":/ansible/server_settings.yml \
#      -v "$SSH_DIR":/root/.ssh \
#      -v "$DEPLOY_SETTINGS_FILE":/ansible/deploy_settings.yml \
#      -v "$STACK_FILE":/ansible/playbooks/swarm/stacks/"$APP".yml \
#      -v ~/.aws:/root/.aws \
#      rcravens/ansible /bin/sh
#
#    exit 1
#
#    envsubst < "${TEMPLATE_FILE}" > "${STACK_FILE}"
#
#    sed -i '' '/platform: linux\/amd64/d' "${STACK_FILE}"

#    docker run --rm --pull=always -it \
#      -v "$INVENTORY_FILE":/ansible/inventory.yml \
#      -v "$SERVER_SETTINGS":/ansible/server_settings.yml \
#      -v "$SSH_DIR":/root/.ssh \
#      -v "$AWS_DIR":/root/.aws \
#      -v "$DEPLOY_SETTINGS_FILE":/ansible/deploy_settings.yml \
#      -v "$STACK_FILE":/ansible/playbooks/swarm/stacks/"$APP".yml \
#      rcravens/ansible ansible-playbook playbooks/swarm/deploy.yml

    run_ansible "$SERVER" \
      -v "$DEPLOY_SETTINGS_FILE":/ansible/deploy_settings.yml \
      -v "$STACK_FILE":/ansible/playbooks/swarm/stacks/"$APP".yml \
      playbooks/deploy.yml
}

function command_help() {
  echo_command "kit <app:server> deploy" "Deploy application to a Docker Swarm server"
}

function command_help_details() {
    echo_divider
    echo_red "Before running this command be sure to copy 'deploy-example.yml' to 'deploy.yml' and update deployment data."
    echo "Examples:"
    echo_example "kit laravel:test deploy" "Deploy the ${RED}laravel${RESET} application to the ${RED}test${RESET} servers"
    echo_example "kit laravel:prod deploy" "Deploy the ${RED}laravel${RESET} application to the ${RED}prod${RESET} servers."
    echo_divider
}