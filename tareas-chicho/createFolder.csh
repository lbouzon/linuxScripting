#!/bin/csh -f
clear
printf  "Folders creator: Tareas-###\n"
set i = 1
if ($1 == "")  then 
printf "Please enter a valid number\n "
else 
	while ($i <= $1)

		if (! -d "tareas-00$i") then
			mkdir 	"tareas-00$i"
			printf "Creating folder tareas-00$i\n"
		else 
			printf "Folder tareas-00$i already exists\n" 
		endif
	@ i++
	end
endif
