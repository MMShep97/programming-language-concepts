
# Takes in: directory
# Outputs 2 numbers delimited by space
# First --> Num of files in directory (and sub)
# Second --> Num of directories (including itself)
FILE_COUNT=$(find "$1" -type f | wc -l) # wc -l --> gets newline count
DIRECTORY_COUNT=$(find "$1" -type d | wc -l)

echo -n "$FILE_COUNT" 
echo " $DIRECTORY_COUNT"
