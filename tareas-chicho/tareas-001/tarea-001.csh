#!/bin/csh -f
echo  "Files creator - Tareas-001"
set i = 1
# if ($1 == "")  then 
#printf "Please enter a valid number\n "
#else 
set Max = 100
 	 while ($i <= $Max)
		set nombre = `printf "arch-%03d.txt" $i` 
		if (! -d "arch-$i") then
			echo "Creando files : $nombre"
			echo "$i" > "$nombre"
		else 
			echo "File $nombre already exists" 
		endif
	@ i++
	end
endif
