#!/usr/bin/env bash


# Ensure host file has entry for this app
eval "./kit host ${APP_DOMAIN}"

# Start the application
echo_yellow "Starting the application"
eval "./kit ${APP_NAME} start"

