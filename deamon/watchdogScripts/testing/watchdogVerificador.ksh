#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -   filename: watchdogVerificador.ksh  
# Lo inicializa el programaVerificador.ksh como un watchdog y 
#                     1  Si no está corriendo, se inicializa como un watchdog. 
#                     2  Genera la lista de deamons 
#				2b. Los deamons se llaman directorycheck:
# Feb 19, 2019
###################################################
#Settings 

porcentageOfTime=0.05
watchdogPidFile="./var/watchdogVerificador.pid"
pidfile="./var/daemons.pid"
scriptName="fakeDaemon.ksh"

if [  -f  $pidfile ];then
    pidfValues=`(cat $pidfile)`
fi 

if [ ! -d var ]; then
    mkdir var 
fi 

echo $$ > $watchdogPidFile

waitTime=1
#echo $((($(date +%s%N) - 1552072477431414701 )/1000000))
:

alias fakeDaemonCmd='(nohup ksh $scriptName  >./var/fake.salida 2>./var/fake.salida) & > /dev/null'

while true; do
    echo "Vamos a esperar $waitTime segundo(s)"
    sleep $waitTime
    start=$SECONDS
    echo "los Segundos son $start"

  # deamonRunning=`ps aux | grep "fakeDaemon.ksh" | grep -v "grep" | wc -l`
    deamonPidList=(`pgrep -f fakeDaemon.ksh`)
    
	echo "Hay ${#deamonPidList[@]} instancias de FakeDaemons running"


	if   [[ -z "${deamonPidList}" ]]; then
	echo "Como no habia ninguno lo corro"
	rm $pidfile
    fakeDaemonCmd
    echo $! >> $pidfile


    elif [   ${#deamonPidList[@]} -lt 6 ]; then
         echo "hay menos de 6" 
    fakeDaemonCmd         
    echo $! >> $pidfile

   
	elif [ ${#deamonPidList[@]} -gt 6 ]; then
            echo "uh, hay banda"
 	    for pid in $deamonPidList;do
		kill -15 $pid
            done
        fakeDaemonCmd
        echo $! >> $pidfile

	fi   
 
    end=$SECONDS

    elapsed=$(($end - $start))


	echo "Elapsed time: $elapsed"

    if [[ "$elapsed" = 0 ]]; then
            elapsed=1
    fi

    let waitTime=$(($elapsed/$porcentageOfTime))
#    waitTime=`echo "$elapsed/$porcentageofTime" | bc`

    if [[ "$waitTime" < 1 ]]; then
        waitTime=1
    fi
done
