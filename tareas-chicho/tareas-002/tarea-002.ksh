#!/bin/ksh
typeset -i Y=1
typeset -i element=("$@")
typeset -i MAX=${element[1]}
typeset -i length=`expr length $@[1]`


 	 while (( $Y < $MAX)); do
		nombre=`printf "arch-%0${length}d.txt" $Y` 
			echo "$i" > "$nombre"
        Y+=1
	done

