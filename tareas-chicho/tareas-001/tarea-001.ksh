#!/bin/ksh
typeset -i Y=1
typeset -i MAX=100
 	 while (( $Y < $MAX)); do
		nombre=`printf "arch-%03d.txt" $Y` 
			echo "$i" > "$nombre"
        Y+=1
	done

