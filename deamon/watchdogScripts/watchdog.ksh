#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -    

#                     1  Si no está corriendo, se inicializa como un watchdog. 
#                     2  Genera la lista de deamons 
#				2b. Los deamons se llaman directorycheck:
# Feb 19, 2019
###################################################
 

set porcentageOfTimeRunnuing = 0.005

# Se fija si ya fue inicializado para no correr en paralelo. 
result=`ps aux | grep "watchdog.sh" | grep -v "grep" | wc -l`
if [ $result -ge 1 ];then 
    echo "Script is already unning"
else 
    echo "Script was not running. Initializing script"
    nohup sh $PWD/watchdog.sh > salida.out 2>salida.out & 
    echo $! > saveW__pid.txt
    printf "\n"
fi


waitTime=0
#echo $((($(date +%s%N) - 1552072477431414701 )/1000000))
:

while true
do
    sleep $waitTime
    start=$SECONDS
    sleep 5
 
#Obtengo la lista de directorios
    directories_to_check=(`psql -c "select directory from directories where username='lbouzon'and enabled=true" -d shelltest001 -U shell  | tail -n +3 | head -n -2`)
    qttyDirectories=${#directories_to_check[@]}


    for directory in $(directories_to_check); do
         nohup sh ./deamonDirectory.ksh $directory > salid$!.out 2 > salid$!.out
         echo $directory $! > deamon.list
    done

    end=$SECONDS
    elapsed=$((end - start))
    let waitTime=$elapsed/$porcentageofRunning
done

#kill the pid that saved when launching. ;
kill -9 `cat save_pid.tx
