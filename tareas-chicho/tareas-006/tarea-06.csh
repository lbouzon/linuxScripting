#!/bin/csh -f
set nuevaLista = (`ls -r *[0-9]*.txt`)
set rv = 0
foreach line ($nuevaLista)
    set number = `echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    set content = `cat $line`
   # echo "_"
   # echo $line
   # echo $content
   # echo "_"
   # echo 
   # echo 		
    @ valor = $number - $1		

   # echo "El valor es $valor"
   # echo "el content es $content" 
    if !($valor == $content) then 
	echo "el file $line tiene un error"
	set rv = 1	 
    endif	
end
exit  $rv

