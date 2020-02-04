find "$1" -type f -name "*.txt" | 

while read file; do
	cat "$file"
done