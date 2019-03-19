#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -   filename: watchdogVerificador.ksh  
# Lo inicializa el programaVerificador.ksh como un watchdog y 
#                     1  Si no está corriendo, se inicializa. 
#                     2  Genera la lista de deamons 
#				2b. Los deamons se llaman daemonPadre.ksh:
# March 19, 2019
###################################################
#Settings 

porcentageOfTime=0.05
watchdogPidFile="./bar/watchdogVerificador.pid"
pidfile="./bar/daemons.pid"
scriptName="daemonPadre.ksh"

if [  -f  $pidfile ];then
    pidfValues=`(cat $pidfile)`
fi 

if [ ! -d bar ]; then
    mkdir bar 
fi 

echo $$ > $watchdogPidFile

waitTime=1
#echo $((($(date +%s%N) - 1552072477431414701 )/1000000))
:

alias fakeDaemonCmd='(nohup ksh $scriptName  >./bar/fake.salida 2>./bar/fake.salida) & > /dev/null'

while true; do
    echo "Vamos a esperar $waitTime segundo(s)"
    sleep $waitTime
    start=$SECONDS
    echo "los Segundos son $start"

    # deamonRunning=`ps aux | grep "fakeDaemon.ksh" | grep -v "grep" | wc -l`
    deamonPidList=(`pgrep -f $scriptName`)

   # echo "Hay ${#deamonPidList[@]} instancias de FakeDaemons running"


    if   [[ -z "${deamonPidList}" ]]; then
#        echo "Como no habia ninguno lo corro"
        rm $pidfile
        fakeDaemonCmd
        echo $! >> $pidfile


    elif [   ${#deamonPidList[@]} -lt 1 ]; then
#        echo "hay menos de 1" 
        fakeDaemonCmd         
        echo $! >> $pidfile


    elif [ ${#deamonPidList[@]} -gt 1 ]; then
#        echo "uh, hay mas de uno"
        for pid in $deamonPidList;do
            kill -15 $pid
        done
        fakeDaemonCmd
        echo $! >> $pidfile

    fi   

    end=$SECONDS

    elapsed=$(($end - $start))

    if [[ "$elapsed" = 0 ]]; then
        elapsed=1
    fi

    let waitTime=$(($elapsed/$porcentageOfTime))
    #    waitTime=`echo "$elapsed/$porcentageofTime" | bc`

    if [[ "$waitTime" < 1 ]]; then
        waitTime=1
    fi
done
