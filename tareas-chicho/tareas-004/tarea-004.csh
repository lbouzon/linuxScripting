#!/bin/csh -f
set nuevaLista = (`ls -r *[0-9]*.txt`)
foreach line ($nuevaLista)
    set number = `echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    @ target = $number + 1
    @ content = $target - 1	
    set length = `expr length $number`
    set doubleTarget = `printf "%0${length}d" $target`
    set newName = `echo $line | sed -re "s/${number}([^0-9]*)"'$'"/$doubleTarget\1/"`
    mv "$line" "$newName"
    echo "$content" > "$newName"	
end
