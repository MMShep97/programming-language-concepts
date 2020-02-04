# Takes in: {source directory} and {destination directory}
# Copy all exe files to dest. from source
# Suggested: use find (-perm -u+x) w/ xargs/loop
# Looked at --> https://www.ostechnix.com/find-copy-certain-type-files-one-directory-another-linux/
# Looked at --> https://superuser.com/questions/208271/find-document-files-and-copy-them-to-another-directory
# Also looked at docs
# rm -rf "$2" # Gets rid of current destination if present
# find "$1" -type f -name '*.txt' -exec cp {} "$2" \; # Finds files w/ ex. and copies to dest file
# find "$1" -exec mv {} "$2" \; # Finds files w/ ex. and copies to dest file
find "$1" -print0 | xargs -0 cp --target-directory="$2"