#!/bin/sh
# Takes in: {stdout file} {stderr file} and {cwd} then arbitrary amount of arguments (subcommand and arguments)
# Script runs subcommand w/ all specified arguments
# Redirect ...
#   stdout --> stdout file,
#   stderr --> stderr file,
#   subcommand's current directory to {cwd} (current working directory)
# TLDR : do subcommands in cwd and print stdout/stderr to respective files (and print exit code to stdout)

USAGE="Usage: $0 {stdout_file} {stderr_file} {cwd} {subcommand w/ parameters}"

if [ "$#" == "0" ]; then
	echo "$USAGE"
	exit 1
fi

cwd=$PWD
# echo 'test' $cwd
stdout_file="$1"
# echo $stdout_file
stderr_file="$2"
# echo $stderr_file
subcommand_cwd="$3"
# echo $subcommand_cwd

subcommand="${@:4}"

(
    cd $subcommand_cwd
    $subcommand >"$cwd"/"$stdout_file" 2>"$cwd"/"$stderr_file"
    echo 'Exit Code: ' $?
)