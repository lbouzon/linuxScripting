#!/bin/ksh

#directorio=$1
#ls -l $directorio > $directorio.contenido 
#insert_time=`date`

#waitTime=0
#while true
#usleep $waitTime
# start=$SECONDS

#nuevoContenido=`(ls -l $directorio)`



#	psql -c "insert into changes ( directory , check_at    , description ,username) values
#	 				('$directorio','$insert_time','$file','lbouzon')" 
#	-d shelltest001 -U shell

#while read line
#do
#echo “$line”
#done << iplist 
   

i=0
j=0

oldList=($(cat old.list | tr -s ' ' | cut -f 9 -d ' ' ))
newList=($(ls -l -I old.list | tail -n +2 | tr -s ' ' | cut -f 9 -d ' ' ))


oldLength=`echo ${#oldList[@]}`
newLength=`echo ${#newList[@]}`

IFS=$'\n'
newFile=(`ls -l -I old.list | tail -n +2`)


#while IFS= $'\n'  read -r line || [[ "$line" ]] ; do
#newFile+=("$line")
#done < `(ls -l -I old.list | tail -n +2)`
#newFile=("${newFile[@]:1}")

#echo "el nuevo files es ${newFile[4]}"


oldFile=()
while IFS= read -r line || [[ "$line" ]] ; do
oldFile+=("$line")
done < old.list
oldFile=("${oldFile[@]:1}")




while [[ $j -lt $oldLength  &&   $i -lt $newLength    ]]  ;do 
	echo "Nuevo ${newList[i]} || Viejo ${oldList[j]}"

	if [[  ${newList[i]} > ${oldList[j]} ]] ;then

	    echo "Borrado file: ${oldList[j]}" 
	    let j++

	elif  [[  ${newList[i]} < ${oldList[j]} ]];then
	    echo "Agregado file: ${newList[i]}" 
	    let i++
	

	else
	#if [[   ${newList[i]} =  ${oldList[j]}     ]] 
		
               if [[ "${newFile[i]}" != "${oldFile[j]}" ]] ; then
         

                     echo "File updated: ${newFile[i]}"
	            # echo "Mismo file: con datos diferentes"
                    # echo "           El nuevo es ${newFile[i]}" 
                    # echo "           El viejo es ${oldFile[j]}" 
	       fi		
        let j++
        let i++
	     
  	    	
	fi

done < old.list


let nl=$newLength-1
let ol=$oldLength-1


if  [[ $j -eq $oldLength ]] ; then
    for a in {$i..$nl}; do 
        echo "New File: ${newList[$a]}"
    done

fi
if  [[ $i -eq $newLength ]] ;then 
   for b in {$j..$ol}; do 
        echo "File Deleted: ${newList[$b]}"
    done
fi
