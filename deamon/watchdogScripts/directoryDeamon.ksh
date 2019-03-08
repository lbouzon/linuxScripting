#!/bin/ksh


#Deamon que corre por un solo directorio y cada una cierta cantidad de tiempo llama a ChangeControler.ksh
#
#:
#
#
#
#








f [${#} -eq 0 ]; then
   echo "Change controler tiene 2 argumentos: directorio a chequear y file del stado anterior "
   echo "uso : ./ChangeControler directorio file"

   exit: 0
fi

if [ -d $1 ] && [  -f $2 ];then
    echo "Procesing $1 $2"
else
    echo "Invalid arguments. ${1} is not a directory or ${2} is not a file "
    exit 1
fi
exit 0

