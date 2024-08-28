#!/usr/bin/env bash

# This file is called by the kit command to allow the template to load
# its own variables into the environment.

# Every template needs one of these as the entry service called when calling docker up
export ENTRY_SERVICE="web"

export MY_EXAMPLE_DIRECTORY="${APP_DIRECTORY}/.env"
