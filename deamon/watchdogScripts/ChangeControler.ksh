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

oldList=($(cat old.list | tr -s ' ' | cut -f 9 -d ' ' | sort))
newList=($(cat new.list | tr -s ' ' | cut -f 9 -d ' ' | sort))


oldLength='${#oldList[@]}'
newLength='${#newLiest[@]}'


while read line;do 
	echo "Nuevo ${newList[i]} || Viejo ${oldList[j]}"
	
	if [[  ${newList[i]} > ${oldList[j]} ]] ;then

		echo "File ${oldList[j]} borrado" 
		let j++

	elif  [[  ${newList[i]} < ${oldList[j]} ]];then
		echo "file ${newList[i]} agregado" 
		let i++
	
	else 
		let j++
		let i++
	fi  
done < old.list

