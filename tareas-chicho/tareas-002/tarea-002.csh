#!/bin/csh -f
echo  "Files creator - Tareas-002"
set i = 1
set length  = `expr length $1`
set Max = 100
if ( $1 != "" && $1 > 0 ) then
 	 while ($i <= $1)
		set nombre =  `printf "arch-%0${length}d.txt" $i` 
		if (! -f "arch-$i") then
			echo "$i" > "$nombre"
		endif
		@ i++
	end
else 
	echo "ingrese valor válido"
endif
