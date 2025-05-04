#!/bin/bash

ssh-keygen-func() {
  local default_dest="$HOME/.ssh/conf.d"
  local algorithm algorithms
  local service key_directory key_length key_name key_name_suffix key_path

  mapfile -t algorithms < <(ssh-keygen --help 2>&1 | grep '\[-t' 2>&1 | sed -E 's/(-t|\[|\]|\|)//g' | awk -F '[][| ]+' '{for(i=4; i<=NF; i++) print $i}')

  read -r -p "Enter key service name: " service
  [[ -z "$service" ]] && printf "\e[31m%s\e[39m\n" "service name is required" && return 1

  # decide key destination dir
  if [[ -d "$default_dest" ]]; then
    key_directory="${HOME}/.ssh/conf.d/${service}"
  else
    key_directory="$HOME/.ssh"
    key_name="_${service}"
  fi

  # decide algorithm
  algorithm=ed25519
  read -r -e -p "Enter key algorithm (${algorithms[*]}): " -i $algorithm algorithm
  [[ -z "$algorithm" ]] && printf "\e[31m%s\e[39m\n" "algorithm is required" && return 1
  if [[ $algorithm == 'rsa' ]]; then
    key_length=3072
    read -r -e -p "Enter key length: " -i $key_length key_length
  fi

  # decide key name
  key_name="id_${algorithm}${key_name}"
  read -r -p "Enter key key name suffix (current key name \"${key_name}\"): " key_name_suffix
  if [[ -n "$key_name_suffix" ]]; then
    key_name="${key_name}_${key_name_suffix}"
  fi
  read -r -e -p "Enter key name (without extension): " -i "$key_name" key_name
  key_path="$key_directory/$key_name"

  # SSHキーを生成
  [[ -d "$key_directory" ]] || mkdir -p "$key_directory" || return 1
  # ssh-keygen -t "$algorithm" -b "$key_length" -f "$key_directory/$key_name" || return 2
  if [[ -z "$key_length" ]]; then
    echo ssh-keygen -t "$algorithm" -f "$key_path"
    ssh-keygen -t "$algorithm" -f "$key_path" || return 2
  else
    ssh-keygen -t "$algorithm" -b "$key_length" -f "$key_path"
    ssh-keygen -t "$algorithm" -b "$key_length" -f "$key_path" || return 2
  fi

  echo -e "\e[32mSSH key pair generated successfully:\e[39m"
  echo "Private key: $key_directory/$key_name"
  echo -e "Public key: $key_directory/$key_name.pub\n"

  read -r -p "Add this key to config (Y/n): " yn
  if [[ ! "$yn" =~ [nN][oO]? ]]; then
    _add_ssh_confing "$key_path" "$service"
  fi
}

_add_ssh_confing() {
  local keypath="${1}"
  local service="${2}"

  local rel_keypath="${1#"$HOME"}"
  local confpath
  local hostname
  local user
  local port

  rel_keypath="${rel_keypath#/}"
  confpath="$(dirname "$keypath")/config"

  while true; do
    read -r -e -p "Enter key hostname (example.com): " -i "$service.com" hostname
    if grep "^Host ${hostname}$" "$confpath" >/dev/null 2>&1; then
      printf "\e[31m%s\n\e[m" "hostname ${hostname} is already exists"
      continue
    fi
    [[ -n $hostname ]] && break
    printf "\e[31m%s\n\e[m" "hostname is required"
  done

  cat <<-EOL >>"$confpath"
		Host $hostname
		  IdentityFile ~/$rel_keypath
	EOL

  read -r -p "Enter key user name (if needed): " user
  [[ -n "$user" ]] && echo "  User $user" >>"$confpath"
  read -r -p "Enter key port (if needed): " port
  [[ -n "$port" ]] && echo "  Port $port" >>"$confpath"

  echo >>"$confpath"

  echo "Added $hostname to config: $confpath"
}
