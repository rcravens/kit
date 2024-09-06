#!/usr/bin/env bash

# Test if a command exists
# e.g., if ! command_exists git; then
#
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# ensure a string exists in a file
# e.g., ensure_string_in_file "alias kit=\"./kit\"" ~/.bashrc
#
ensure_string_in_file() {
	STRING="$1"
	FILE="$2"
	#echo "STRING: ${STRING}, FILE: ${FILE}"
	if ! grep -qF "${STRING}" "${FILE}"; then
		echo -e "${STRING}" >> "${FILE}"
		return 0
	fi
	return 1
}

# set variable value in a file
# assumes data is like VAR=VAL
# will either update the value or add a line to the end of the file
# e.g., set_value_in_file "DB_HOST" "localhost" ".env"
set_value_in_file() {
	VARIABLE="$1"
	NEW_VALUE="$2"
	FILE="$3"
	#echo "VARIABLE: ${VARIABLE}, NEW_VALUE: ${NEW_VALUE}, FILE: ${FILE}"
	if ! grep -qF "${VARIABLE}=" "${FILE}"; then
		#echo "variable not found in file...append it to the end"
		echo -e "${VARIABLE}=${NEW_VALUE}" >> "${FILE}"
	else
		#echo "variable was found....update the value"
		sed -i '' -e "s|${VARIABLE}=.*|${VARIABLE}=${NEW_VALUE}|" "${FILE}"
	fi
}

# get the bash file for the user
# e.g., BASH_FILE=$(bash_file)
#
bash_file() {
    SHELL_TYPE=$(basename "$SHELL")

    case "$SHELL_TYPE" in
        bash)
            # Typically use ~/.bashrc for interactive shells and ~/.bash_profile for login shells
            if [ -f ~/.bash_profile ]; then
                echo ~/.bash_profile
            else
                echo ~/.bashrc
            fi
            return 0
            ;;
        zsh)
            echo ~/.zshrc
            return 0
            ;;
        ksh)
            echo ~/.kshrc
            return 0
            ;;
        fish)
            echo ~/.config/fish/config.fish
            return 0
            ;;
        *)
            echo "Unsupported shell: $SHELL_TYPE"
            return 1
            ;;
    esac
}

# ensure a bash alias exists
# e.g., create_bash_alias kit "./kit"
#
create_bash_alias() {
	local ALIAS="$1"
	local COMMAND="$2"
	local STRING="alias ${ALIAS}=\"${COMMAND}\""

  BASH_FILE=$(bash_file)

	echo "ALIAS=${ALIAS}"
	echo "COMMAND=${COMMAND}"
	echo "STRING=${STRING}"
	echo "BASH_FILE=${BASH_FILE}"

	if set_value_in_file "alias $ALIAS" "${COMMAND}" "${BASH_FILE}"; then
		# file was modified...source it
		# shellcheck source=/dev/null
		source "${BASH_FILE}"
	fi
}

capitalize() {
  local STR="$1"
  CAP_STR="$(tr '[:lower:]' '[:upper:]' <<< "${STR:0:1}")${STR:1}"
  echo "${CAP_STR}"
}

update_env_using_template() {
  # This function takes two arguments:
  # 1. The path to the template file
  # 2. The destination path of the resulting .env file
  #
  # The function will read the template file and create a new file with the
  # templated values replaced by the user responses (or the default value)
  #
  # The template file will have lines using the following format:
  # VAR_NAME1="VALUE"             <--lines like this are ignored
  # VAR_NAME2="?PROMPT|DEFAULT"   <--lines where the value starts with a ? are templates
  #...
  # EXAMPLE="?Enter the HTTPS port|443"
  #
  # The function will prompt the user for input for each variable, or use the default
  # value if provided. The function will then create a new file named.env in the

  local TEMPLATE_FILE="$1"
  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file not found: $TEMPLATE_FILE"
    return 1
  fi

  local ENV_FILE="$2"
  local ENV="$3"

  # Create the name value pairs in the form of a dictionary
  declare -A NAME_VALUES
  NAME_VALUES["APP_NAME"]=$APP_NAME
  NAME_VALUES["APP_ENVIRONMENT"]=${ENV:-dev}

  while IFS='=' read -ra line; do
    VAR_NAME="${line[0]}"
    VAR_VALUE="${line[1]}"
    if [ -n "$VAR_VALUE" ]; then
      VAR_VALUE="${VAR_VALUE//\"/}"
      if [ "${VAR_VALUE:0:1}" == "?" ]; then
        # Found a templated variable

        # Strip off leading question mark
        VAR_VALUE="${VAR_VALUE:1}"

        # Split string on the | to provide prompt and default value
        PROMPT=$(echo $VAR_VALUE | awk -F '|' '{print $1}')
        DEFAULT_VALUE=$(echo $VAR_VALUE | awk -F '|' '{print $2}')

        # Prompt the user for input, or use the default value if provided
        read -p "${GREEN}${PROMPT} [default: $DEFAULT_VALUE]: ${RESET}" RESPONSE </dev/tty
        RESPONSE=${RESPONSE:-$DEFAULT_VALUE}
        NAME_VALUES[$VAR_NAME]=$RESPONSE
      fi
    fi
  done < "${TEMPLATE_FILE}"

#  echo "${NAME_VALUES[@]}"
#  echo "${!NAME_VALUES[@]}"

  # Copy the template file into place if an existing .env is not present
  if [ ! -f "$ENV_FILE" ]; then
    cp "${ENV_TEMPLATE_FILE}" "${ENV_FILE}"
  fi

  # Loop over all the dictionary keys and replace the values in the file with the values
  for KEY in "${!NAME_VALUES[@]}"; do
    VALUE="${NAME_VALUES[$KEY]}"
    sed -i.bak "s|$KEY=.*|$KEY=$VALUE|" "${ENV_FILE}"
  done
  rm "${ENV_FILE}.bak"

  return 0
}
