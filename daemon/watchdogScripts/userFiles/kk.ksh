#!/bin/ksh



CurrentFile=()
while IFS= read -r line || [[ "$line" ]] ; do
File+=("$line")
done < $1 
File=("${oldFile[@]:1}")


