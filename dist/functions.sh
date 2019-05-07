#!/bin/bash
function usage() {
	if [ -n "$1" ]; then
		echo -e "${COLOR_RED}👉 $1${COLOR_DEFAULT}\n";
	fi

	echo "Usage: $0 [-p package]"
	echo "  -p, --package     Run a single package only"
	echo "  -c, --config      Define config file up front"
  echo "  -h, --help        This message"
	echo "  -v, --verbose"
	echo ""
	echo "Example: $0 --package dotfiles"
	exit 1
}

function print_intro() {
	echo "                                   ";
	echo "                                   ";
	echo "            _ __ ___   __ _  ___ _   _ _ __  ";
	echo "           | '_ \` _ \ / _\` |/ __| | | | '_ \ ";
	echo "           | | | | | | (_| | (__| |_| | |_) |";
	echo "           |_| |_| |_|\__,_|\___|\__,_| .__/ ";
	echo "                                      | |    ";
	echo "                                      |_|    ";
	echo ""
  echo "";
	echo "Welcome to macup - your mac's best friend!"
	echo "";
}

function print_header {
  echo ""
	print_colored "========================================================================"
	print_colored " $1" 'blue'
	print_colored "========================================================================"
}

function print_colored {
  local text="$1"
  local color="$2"

  if [ "$color" == 'red' ]; then
    echo -e "${COLOR_RED}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'green' ]; then
    echo -e "${COLOR_GREEN}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'yellow' ]; then
    echo -e "${COLOR_YELLOW}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'blue' ]; then
    echo -e "${COLOR_BLUE}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'magenta' ]; then
    echo -e "${COLOR_MAGENTA}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'cyan' ]; then
    echo -e "${COLOR_CYAN}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'light-gray' ]; then
    echo -e "${COLOR_LIGHT_GRAY}${text}${COLOR_CLEAR}"
  elif [ "$color" == 'dim' ]; then
    echo -e "${COLOR_DIM}${text}${COLOR_CLEAR}"
  else
    echo -e "${COLOR_CLEAR}${text}" 
  fi
}

function report_from_package {
  local message=$1
  local color=$2
  print_colored " -> $message" "$color"
}

function get_config {
  local config=$1
  
  if [ -f "$config" ]; then
    echo "$config"
  elif [ -f "./dist/$config.coffee" ]; then
    echo "./dist/$config.coffee"
  elif [ -f "./dist/$config" ]; then
    echo "./dist/$config"
  fi
}

function print_config_options {
  echo "The following configurations was found in your repo:"
  echo ''
  
  local counter=1
  declare -a files
  for i in ./dist/*.config; do
    [ -f "$i" ] || break
    files+=("$i")
    echo "$counter) ${i}"
    counter=$(($counter+1))
  done
  echo ''
  print_colored "Choose your config file: \c" "green"
}

function print_packages_in_config {
  macup_packages=$1
  echo ''
  print_colored 'Based on your configuration, the following packages will be installed:'
  echo ''
  for ((i=0; i<${#macup_packages[@]}; ++i)); do
    echo " - ${macup_packages[i]}"
  done
  echo ''
}

function select_config_option {
  local selected_file_no=$1
  local counter=1
  declare -a files
  for i in ./dist/*.config; do
    [ -f "$i" ] || break
    files+=("$i")
    if [ "$counter" == "$selected_file_no" ]; then
      echo ${files[$(($selected_file_no-1))]}
      return
    fi

    counter=$(($counter+1))
  done
}
