#!/bin/bash

#### Package: macup/macup-core
#### Description: Bootstrapping the bash application

macup_core_dir=$(dirname $0)/dist/packages/macup-core

# shellcheck disable=SC1090
. "$macup_core_dir"/constants.sh

# shellcheck disable=SC1090
. "$macup_core_dir"/functions.sh

# parse params
while [[ "$#" -gt 0 ]]; do case $1 in
  -p|--package) input_package="$2"; shift;;
  -c|--config) input_config="$2"; shift;;
  -h|--help) usage; exit 1; shift;;
  -v|--verbose) input_verbose=1; shift;;
esac; shift; done


# Check if configuration provided by input exist
if [ -n "$input_config" ]; then
  macup_config_file=$(get_config "$input_config")
fi

# clear

# Print the intro image
print_intro

# If we still don't have a valid config file, the user should select a valid file
if [ -z "$macup_config_file" ]; then
  print_config_options
  read -r input_config
  macup_config_file=$(select_config_option $input_config)
fi

# Print debug information if in verbose mode
if [ -n "$input_verbose" ]; then
  print_colored "-----------"
  print_colored "Debug information: " "light-gray"
  print_colored " macup_config_file: $macup_config_file" "yellow"
  print_colored " macup_install_package: $input_package" "yellow"
  print_colored "-----------"
fi

if [ -z "$macup_config_file" ]; then
  print_colored "No valid config file provided. Exiting." "red"
  exit 0
fi

print_colored "Valid config file provided: $macup_config_file" "green"

# shellcheck disable=SC1090
. "$(dirname "$0")/dist/packages/macup-core/variables.sh"

# shellcheck disable=SC1090
. "$macup_config_file"

#
# Install packages
#
# verify params
if [ -n "$input_package" ]; then
  print_header "Installing/updating MacUP package: ./dist/packages/macup-${input_package}"
  # bash ./dist/packages/macup-${input_package}/run.sh $macup_config_file
  
  # shellcheck disable=SC1090
  . "./dist/packages/macup-${input_package}/run.sh"
else
  # Check if the macup_packages array is empty
  
  # todo: check if declared first!
  # shellcheck disable=SC2154
  if [ ${#macup_packages[@]} -eq 0 ]; then
    print_colored "\$macup_packages (array) is empty, and no packages will be installed. See documentation" "warning"
  else
    print_packages_in_config "$macup_packages"
    print_colored 'Proceed? (y/n) \c' 'blue'
    read -r proceed

    if [ "$proceed" == 'y' ]; then
      for ((i=0; i<${#macup_packages[@]}; ++i)); do
        print_header "Installing/updating macup package: ${macup_packages[i]}"

        # Run the installation script for the package
        # shellcheck disable=SC1090
        bash ./dist/packages/macup-core/runpackage.sh "${macup_packages[i]}" "$macup_config_file"
      done
    fi
  fi
fi

rm -r "$PWD/.tmp"

exit 0
