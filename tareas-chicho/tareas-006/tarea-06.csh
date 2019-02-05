#!/bin/csh -f

if ( 1 != $#argv )then
   echo "Ony 1 argument is accepted"
   exit 1
endif

set test = `echo $1 | grep '^[0-9]*$'`
echo $test
if ($test) then
    echo "Argument is not a number"
    exit 1
endif 

set nuevaLista = (`ls -r *[0-9]*.txt`)
set rv = 0
foreach line ($nuevaLista)
    set number = `echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    set content = `cat $line`
    @ valor = $number - $1		

    if !($valor == $content) then 
	echo "el file $line tiene un error"
	set rv = 1	 
    endif	
end
exit  $rv

