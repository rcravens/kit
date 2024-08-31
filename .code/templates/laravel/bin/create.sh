#!/usr/bin/env bash

# Create code directory outside of image to share as a volume
if [ ! -d "${PATH_TO_CODE}" ]; then
    echo_yellow "Creating directory ${PATH_TO_CODE}"
    mkdir -p "${PATH_TO_CODE}"

    IS_DELETE_GIT_DIRECTORY=false
    if [ -z "${CODE_REPO_URL}" ]; then
        CODE_REPO_URL="https://github.com/laravel/laravel.git"
        IS_DELETE_GIT_DIRECTORY=true
    fi

    echo_yellow "Cloning Laravel Project From: ${CODE_REPO_URL}"
    git clone "${CODE_REPO_URL}" "${PATH_TO_CODE}"
    if $IS_DELETE_GIT_DIRECTORY; then
       echo_yellow "Deleting the cloned .git repository"
       rm -rf "${PATH_TO_CODE}/.git"
    fi

    if [ ! -f "${PATH_TO_CODE}/.env" ]; then
        if [ -f "${LARAVEL_ENV_FILE}" ]; then
            echo_yellow "Copying .env file. Source: ${LARAVEL_ENV_FILE}"
            cp "${LARAVEL_ENV_FILE}" "${PATH_TO_CODE}"/.env
        else
            if [ -f "${PATH_TO_CODE}/.env.example" ]; then
                echo_yellow "Creating the .env file from .env.example"
                cp "${PATH_TO_CODE}"/.env.example "${PATH_TO_CODE}"/.env
                sed -i .bak "s|APP_NAME=Laravel|APP_NAME=${APP_NAME}|" "${PATH_TO_CODE}"/.env
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

echo_yellow "Starting the application"
eval "./kit ${APP_NAME} start"
# HACK: Don't understand why the original start fails to mount the volume
echo_yellow "Restarting the container to ensure the volume is mounted correctly....hackety hack..."
eval "./kit ${APP_NAME} stop"
eval "./kit ${APP_NAME} start"

# Ensure host file has entry for this app
eval "./kit ${APP_NAME} host"

# Call the build.sh script for the template
if [ -f "$APP_DIRECTORY/bin/commands/build.sh" ]; then
  echo_yellow "Found a build file for this template."
  eval "./kit ${APP_NAME} build"
else
  echo_yellow "No build file found for this template."
fi

echo_yellow "Opening browser tab"
eval "./kit ${APP_NAME} open"
