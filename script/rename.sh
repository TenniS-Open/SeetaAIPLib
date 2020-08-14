#!/usr/bin/env bash

usage="Usage: $0 [project_name [cmake_root]]"

cmakeroot=$2

if [ -z "$2" ]; then
  cmakeroot=$(pwd)
fi

# find CMakeLists.txt
# shellcheck disable=SC2010
cmakefile=$(ls "$cmakeroot" | grep -E "(C|c)(M|m)(A|a)(K|k)(E|e)(L|l)(I|i)(S|s)(T|t)(S|s)\.(T|t)(X|x)(T|t)")

cmakepath="$cmakeroot/$cmakefile"

if [ ! -f "$cmakepath" ]; then
  echo "[ERROR] Can not found any CMakeLists.txt in $cmakeroot"
  echo "$usage"
  exit 1
fi

# find project name
# shellcheck disable=SC2002
project_command=$(cat "$cmakepath" | grep -E '^(project|PROJECT)(.*)')
if [ -z "$project_command" ]; then
  echo "[ERROR] Can not found project command, only project(XXX) or PROJECT(XXX) supported."
  echo "$usage"
  exit 2
fi

oldname=$(echo "$project_command" | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
project=$(echo "$project_command" | awk -F'(' '{print $1}')

echo "Editing \"$cmakepath\"."

# get new name
newname=$1

if [ -z "$1" ]; then
  # shellcheck disable=SC2162
  echo -n "Rename project($oldname) to: "
  read -r newname
fi

# strip newname
newname=$(echo "$newname" | awk '{gsub(/^\s+|\s+$/, "");print}')

# check newname if valid
newname_check=$(echo "$newname" | grep -E "^[A-Za-z_][A-Za-z0-9_]*$")

if [ -z "$newname_check" ]; then
  echo "[ERROR] Project($newname) is invalid, nothing will happen. It must like \"[A-Za-z_][A-Za-z0-9_]*\"."
  echo "$usage"
  exit 3
fi

if [ -n "$1" ]; then
  echo "Rename project($oldname) to: $newname"
fi

expr="s/^$project_command/$project($newname)/"
tempfile="$cmakeroot/.$cmakefile.sed"

if ! ( sed "$expr" "$cmakepath" > "$tempfile" && mv "$tempfile" "$cmakepath" );
then
  echo "[ERROR] What a Terrible Failure! Rename failed!"
  echo "$usage"
  exit 4
fi
