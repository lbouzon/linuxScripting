#!/bin/ksh

####################################################################
#Author: Lisandro Bouzon 
#Description:  
#             command          arg1       arg 
#            ./ChangeControler directorio file
#
#El script recibe 2 argumentos, "directorio" que es el directorio donde realizara el chequeo de los datos y 
#			        "file" donde tiene el estado anterior del directorio

#  Salida:          muestra el resultado de los cambios que hubo en una lista       

###############################################


if [${#} -eq 0 ]; then
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

directorio=$1

i=0
j=0

oldList=($(cat old.list | tr -s ' ' | cut -f 9 -d ' ' ))
newList=($(ls -l $directorio | tail -n +2 | tr -s ' ' | cut -f 9 -d ' ' ))

oldLength=`echo ${#oldList[@]}`
newLength=`echo ${#newList[@]}`

IFS=$'\n'
newFile=(`ls -l -I old.list | tail -n +2`)

oldFile=()
while IFS= read -r line || [[ "$line" ]] ; do
oldFile+=("$line")
done < old.list
oldFile=("${oldFile[@]:1}")

while [[ $j -lt $oldLength  &&   $i -lt $newLength    ]]  ;do 

	if [[  ${newList[i]} > ${oldList[j]} ]] ;then

	    echo "Borrado file: ${oldList[j]}" 
	    let j++

	elif  [[  ${newList[i]} < ${oldList[j]} ]];then
	    echo "Agregado file: ${newList[i]}" 
	    let i++

	else
            if [[ "${newFile[i]}" != "${oldFile[j]}" ]] ; then
                echo "File updated: ${newFile[i]}"
	    fi		
        let j++
        let i++
	fi

done < old.list


let nl=$newLength-1
let ol=$oldLength-1

if  [[ $j -eq $oldLength && $i -lt $newLength ]] ; then
    for a in {$i..$nl}; do 
        echo "New File: ${newList[$a]}"
    done

fi

if  [[ $i -eq $newLength && $j -lt $oldLength ]] ;then 
   for b in {$j..$ol}; do 
        echo "File Deleted: ${newList[$b]}"
    done
fi
