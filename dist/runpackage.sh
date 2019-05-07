#!/bin/bash
package_script=$1
config_file=$2
. "./dist/packages/macup-core/functions.sh"
. "./dist/packages/macup-core/variables.sh"
. "$config_file"
. "./dist/packages/macup-$package_script/run.sh"
