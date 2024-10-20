#!/usr/bin/env bash

# Helper function to run ansible playbooks
function run_ansible()
{
  # Usage example:
  # run_ansible <SERVER> -v "aaa:bbb" -v "ccc:ddd" <PLAYBOOK>
#  set -o xtrace
  SERVER=$1
  shift 1

  SERVER_DIRECTORY="${ROOT_DIRECTORY}/servers/${SERVER}"
  SSH_DIR="${SERVER_DIRECTORY}/.ssh"

  AWS_DIR="${SERVER_DIRECTORY}/.aws"
  if [ ! -d "$AWS_DIR" ]; then
    # Try to copy the default credentials into this directory
    cp -r ~/.aws "$AWS_DIR"
  fi

#  echo "APP: ${APP}"
#  echo "ROOT_DIRECTORY: ${ROOT_DIRECTORY}"
#  echo "SERVER: ${SERVER}"
#  echo "SERVER_SETTINGS FILE: ${SERVER_SETTINGS_FILE}"
#  echo "SSH_DIR: ${SSH_DIR}"
#  echo "AWS_DIR: ${AWS_DIR}"
#  echo "$@"

  if [ -z "$SERVER" ]; then
    echo_red "Server name is required."
    exit 1
  fi

  if [ ! -d "$SSH_DIR" ]; then
    echo_red "SSH directory not found: ${SSH_DIR}"
    exit 1
  fi

  if [ ! -d "$AWS_DIR" ]; then
    echo_red "AWS credential directory not found: ${AWS_DIR}"
    exit 1
  fi

  # Create array of standard volumes
  local volumes=()
  volumes+=("-v" "$SERVER_DIRECTORY:/ansible/server")
  volumes+=("-v" "$SSH_DIR:/root/.ssh")
  volumes+=("-v" "$AWS_DIR:/root/.aws")

  local other_args=()
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -v)
        # Add this to the volumes
        volumes+=("-v" "$2")
        shift 2
        ;;
      *)
        other_args+=("$1")
        shift 1
        ;;
    esac
  done

#  echo "VOLUMES:"
#  echo "${volumes[@]}"
#  echo "OTHER ARGS:"
#  echo "${other_args[@]}"
#  echo "$@"
#  echo ${#other_args[@]}
  if [ ${#other_args[@]} -gt 1 ]; then
    echo "Expecting only one argument."
    exit 1
  fi

  if [ "${other_args[0]}" == "ssh" ]; then
    ANSIBLE_CMD="/bin/sh"
    ARGS=""
  else
    ANSIBLE_CMD="ansible-playbook"
    ARGS="${other_args[0]}"
  fi
  echo "ANSIBLE_CMD: $ANSIBLE_CMD"


  docker run --rm --pull=always -it \
    "${volumes[@]}" \
    rcravens/ansible "${ANSIBLE_CMD}" "${ARGS}"
#  set +o xtrace
}