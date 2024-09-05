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
