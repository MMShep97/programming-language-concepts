#!/bin/sh
subcommand="${@:1}"
exec strace $subcommand 2>&1 | 
awk '{split($0, a, "\("); print a[1]}' | sort -u -k 1