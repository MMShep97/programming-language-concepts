# Takes in: {directory} and {name tag}
# Create tar archive in format (name_tag)_(current_time).tar
# (name_tag) is string specified by user as second argument
TIME=$(date +"%s")
NAME="$2_$TIME"
tar -cf $NAME.tar $1
