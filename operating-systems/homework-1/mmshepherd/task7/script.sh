COMMAND="${@:1}"
echo "$COMMAND"
# exec strace $COMMAND 2>&1 | awk '{split($0, a, "\("); print a[1]}' | sort -u -k 1