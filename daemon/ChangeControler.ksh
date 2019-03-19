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


#________  Argument Validaton  ________#
if [ ${#} -eq 0 ]; then
    echo "ChangeConstroler.ksh : missing arguments"  #  echo "uso : ./ChangeControler directorio file"
    exit: 0
fi

if [ -d $1 ] && [  -f $2 ];then
  echo "Procesing $1 $2"
else
    echo "ChangeConstroler.ksh: Wrong argument type"
    exit 1
fi

#__________   Variables  ___________________ #
typeset -a result

directorio=$1
file=$2

i=0
j=0

oldList=($(cat $file  | tr -s ' ' | cut -f 9 -d ' ' ))
newList=($(ls -l $directorio | tail -n +2 | tr -s ' ' | cut -f 9 -d ' ' ))

oldLength=`echo ${#oldList[@]}`
newLength=`echo ${#newList[@]}`

IFS=$'\n'
newFile=(`ls -l  "$1" | tail -n +2`)

oldFile=()


while IFS= read -r line || [[ "$line" ]] ; do
    oldFile+=("$line")
done < $file
oldFile=("${oldFile[@]:1}")

#___________________________________________________________________________

while [[ $j -lt $oldLength  &&   $i -lt $newLength    ]]  ;do 

    if [[  ${newList[i]} > ${oldList[j]} ]] ;then

        result+=(`echo "Borrado file: ${oldList[j]}"`)
        let j++

    elif  [[  ${newList[i]} < ${oldList[j]} ]];then
        result+=(`echo "Agregado file: ${newList[i]}"`) 
        let i++

    else
        if [[ "${newFile[i]}" != "${oldFile[j]}" ]] ; then
          result+=(`echo "File updated: ${newFile[i]}"`)
        fi		
        let j++
        let i++
    fi

done < $2

let nl=$newLength-1
let ol=$oldLength-1

if  [[ $j -eq $oldLength && $i -lt $newLength ]] ; then
    for a in {$i..$nl}; do 
        result+=(`echo "New File: ${newList[$a]}"`)
    done

fi

if  [[ $i -eq $newLength && $j -lt $oldLength ]] ;then 
    for b in {$j..$ol}; do 
         result+=(`echo "File Deleted: ${newList[$b]}"`)
    done
fi


# Update SQL with changes
for line in ${result[@]};  do 
    psql -c "INSERT INTO changes(change_id, directory, check_at, description, username) VALUES (DEFAULT, '$1', now(), '$line', 'lbouzon')" -d shelltest001 -U shell
done

# Update status file with current directory status.
printf "%s\n" "${newFile[@]}" > "$file"