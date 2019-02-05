#!/bin/ksh
for line  in `ls -r *[0-9]*.txt` ;do
    number=`echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    let target=number+$1
    typeset -i len=`expr length $number`
    doubleTarget=`printf "%0${len}d" $target`
    newName=`echo $line | sed -re "s/${number}([^0-9]*)"'$'"/$doubleTarget\1/"`
    mv "$line" "$newName"
done
