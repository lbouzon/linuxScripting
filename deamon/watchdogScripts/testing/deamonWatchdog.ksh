#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -    

#                     1  Si no está corriendo, se inicializa como un watchdog. 
#                     2  Genera la lista de deamons 
#				2b. Los deamons se llaman directorycheck:
# Feb 19, 2019
###################################################
 
porcentageOfTime=0.5

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

alias minuteCmd='(nohup sh minutetrackerD.sh  >minute.salida 2>minute.salida) & > /dev/null'

while true
do
    echo "vamos a esperar $waitTime"
    sleep $waitTime
    start=$SECONDS
    sleep 5
   
    deamonRunning=`ps aux | grep "minutetrackerD.sh" | grep -v "grep" | wc -l`
    deamonPidList=(`pgrep -f minutetrackerD.sh`)
    
	echo "la cantidad de pids de minutracker es ${#deamonPidList[@]}"

	if   [[ -z "${deamonPidList}" ]]; then
	echo "no habia ninguno"
	minuteCmd
	

	elif [ ${#deamonPidList[@]} -gt 1 ]; then
            echo "uh, hay banda"
 	    for pid in $deamonPidList;do


		kill -15 $pid
            done
        minuteCmd
	fi   

 
    end=$SECONDS
    elapsed=$(($end - $start))

	echo "elapsed : $elapsed"
	echo "el porcentaje es $porcentageOfTime"	
    let waitTime=$(($elapsed/$porcentageOfTime))
done

#kill the pid that saved when launching. ;
kill -9 `cat save_pid.tx

