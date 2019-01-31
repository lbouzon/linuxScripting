#!/bin/ksh
let Y=1
set -A element "$@"
let MAX=${element[0]}
let length=`expr length $MAX`

while [[ $Y -le $MAX ]]; do
    nombre=`printf "arch-%0${length}d.txt" $Y` 
    echo "$Y" > "$nombre"
    let ++Y
done

