#!/usr/bin/env bash

# Here you can perform any steps that need to happen to create the
# application in the ../code/[APP_NAME] directory

# Here are a few example:
# 1. Create the directory
# 2. Git clone the code into the directory
# 3. Install dependencies (if any)
# 4. Run any necessary setup scripts

# Take a look at the other templates to get some ideas.

# End the end you can use the following to call 'kit start' to start your application
echo_yellow "Starting the application"
eval "./kit ${APP_NAME} start"
