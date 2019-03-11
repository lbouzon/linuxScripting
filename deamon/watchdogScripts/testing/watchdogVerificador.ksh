#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -    

#                     1  Si no está corriendo, se inicializa como un watchdog. 
#                     2  Genera la lista de deamons 
#				2b. Los deamons se llaman directorycheck:
# Feb 19, 2019
###################################################
#Settings 

porcentageOfTime=0.05
pidFile="./var/fake.pid"
scriptName="fakeDaemon.ksh"



if [  -f  $pidFile ];then
    pidfValues=`(cat $pidFile)`







echo $$ > $pidFile


waitTime=1
#echo $((($(date +%s%N) - 1552072477431414701 )/1000000))
:

alias fakeDaemonCmd='(nohup sh $scriptName  >./var/fake.salida 2>./var/fake.salida) & > /dev/null'

while true
do
    echo "vamos a esperar $waitTime"
    sleep $waitTime
    start=$SECONDS
   
  # deamonRunning=`ps aux | grep "fakeDaemon.ksh" | grep -v "grep" | wc -l`
    deamonPidList=(`pgrep -f fakeDaemon.ksh`)
    
	echo "Hay ${#deamonPidList[@]} instancias de FakeDaemons running"

	if   [[ -z "${deamonPidList}" ]]; then
	echo "Como no habia ninguno lo corro"
	fakeDaemonCmd
    rm $pidFile
    echo $! >> $pidFile


    elif [   ${#deamonPidList[@]} -lt 6 ]; then
         echo "hay pocos" 
    fakeDaemonCmd         
    echo $! >> $pidFile

   
	elif [ ${#deamonPidList[@]} -gt 6 ]; then
            echo "uh, hay banda"
 	    for pid in $deamonPidList;do
		kill -15 $pid
            done
        fakeDaemonCmd
        echo $! >> $pidFile

	fi   

 
    end=$SECONDS
    elapsed=$(($end - $start))

	echo "Elapsed time: $elapsed"
	echo "El porcentaje es $porcentageOfTime"	
    let waitTime=$(($elapsed/$porcentageOfTime))
done

#kill the pid that saved when launching. ;


#kill -15 `cat save_pid.tx

