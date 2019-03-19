#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -    filename: programaVerificador.ksh


#                     1  Verifica que el watchdogVerificador.ksh
#                               Si no está corriendo, lo inicia. 
#                               Se fija si el pid del watchdogVerificador es el mismo que en el file , si no lo es , corre. 
# Mar 19, 2019
###################################################
#Settings 
porcentageOfTime=0.5
pidFile="./bar/watchdogVerificador.pid"
scriptName="watchdogVerificador.ksh"

if [  -f  $pidFile ]; then

    pidValue=`cat $pidFile`

    wdPresent=`ps -eo pid,cmd | grep $pidValue |grep $scriptName | wc -l`

    if [[  "$wdPresent" = 1  ]]; then
        echo "Script is already running"
        exit 0   
    fi
else 
    if [ ! -d "./bar" ]; then
        mkdir bar
    fi
fi

echo "Script was not running. Initializing script"
(nohup ksh $scriptName > ./bar/watchdog.out 2>./bar/watchdog.out) & > /dev/null
