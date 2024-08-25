#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -n "$1" ]; then
        if [ "$1" == "force" ] || [ "$1" == "-f" ] || [ "$1" == "-force" ] || [ "$1" == "--force" ]; then
            echo_red "Deleting directory: ${PATH_TO_CODE}"
            rm -rf "${PATH_TO_CODE}"
        fi
    fi

    if [ "$ENV" == "dev" ]; then
        # Create code directory outside of image to share as a volume
        if [ ! -d "${PATH_TO_CODE}" ]; then
            echo_yellow "Creating directory ${PATH_TO_CODE}"
            mkdir -p "${PATH_TO_CODE}"

            if [ -z "${CODE_REPO_URL}" ]; then
                CODE_REPO_URL="https://github.com/laravel/laravel.git"
            fi

            echo_yellow "Cloning Laravel Project From: ${CODE_REPO_URL}"
            git clone "${CODE_REPO_URL}" "${PATH_TO_CODE}"

            if [ ! -f "${PATH_TO_CODE}/.env" ]; then
                if [ -f "${LARAVEL_ENV_FILE}" ]; then
                    echo_yellow "Copying .env file. Source: ${LARAVEL_ENV_FILE}"
                    cp "${LARAVEL_ENV_FILE}" "${PATH_TO_CODE}"/.env
                else
                    if [ -f "${PATH_TO_CODE}/.env.example" ]; then
                        echo_yellow "Creating the .env file from .env.example"
                        cp "${PATH_TO_CODE}"/.env.example "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|APP_NAME=Laravel|APP_NAME=${COMPOSE_PROJECT_NAME}|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|APP_URL=.*|APP_URL=https://${APP_DOMAIN}:${HTTPS_ON_HOST}|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|DB_CONNECTION=.*|DB_CONNECTION=mysql|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_HOST=.*|DB_HOST=mysql|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_HOST_READ=.*|DB_HOST_READ=mysql|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_HOST_WRITE=.*|DB_HOST_WRITE=mysql|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_PORT=.*|DB_PORT=3306|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_DATABASE=.*|DB_DATABASE=${MYSQL_DATABASE}|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_USERNAME=.*|DB_USERNAME=${MYSQL_USER}|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|.*DB_PASSWORD=.*|DB_PASSWORD=${MYSQL_PASSWORD}|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|SESSION_DRIVER=.*|SESSION_DRIVER=redis|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|QUEUE_CONNECTION=.*|QUEUE_CONNECTION=redis|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|CACHE_STORE=.*|CACHE_STORE=redis|" "${PATH_TO_CODE}"/.env
                        sed -i .bak "s|REDIS_HOST=.*|REDIS_HOST=redis|" "${PATH_TO_CODE}"/.env
                        rm "${PATH_TO_CODE}"/.env.bak
                    fi
                fi
            else
                echo_yellow "Found existing .env file"
            fi

        else
            echo_yellow "Code directory already exists at: ${PATH_TO_CODE}"
        fi
    fi

    echo_yellow "Building the Docker images"
    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" build "${ENTRY_SERVICE}"
#        docker compose -f ${COMPOSE_FILE} --env-file ${ENV_FILE} build --no-cache ${ENTRY_SERVICE}

    echo_yellow "Starting the application"
    source "start.sh"
    command_run "$@"

    if [ -f "/etc/hosts" ]; then
        echo_yellow "Ensuring domain exists in host file"
        matches_in_hosts="$(grep -n "${APP_DOMAIN}" /etc/hosts | cut -f1 -d:)"
        if [ -n "${matches_in_hosts}" ]; then
            echo_yellow "Domain exists already"
        else
            sudo -- sh -c -e "echo '127.0.0.1       ${APP_DOMAIN}' >> /etc/hosts"
            echo_yellow "Domain added"
        fi
    else
        echo_yellow "Host file not found. You may need to add the domain manually."
    fi

    echo_yellow "Opening browser tab"
    source "open.sh"
    command_run "$@"
}

function command_help() {
  echo_command "kit create" "Creates a new Laravel application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit create"
    echo_example "kit create --force"
    echo_divider
}