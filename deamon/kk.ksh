#!/bin/ksh
if [ ${#} -ne 2 ]; then
   echo "Error:  Los argumentos son ${#} y deben ser 2"
   exit 1	 
fi


if [ -d $1 ] && [  -f $2 ];then
    echo "Procesing $1 $2"
else 
    echo "Invalid arguments. ${1} is not a directory or ${2} is not a file "	
    exit 1
fi 
exit 0
