#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog -    filename: programaVerificador.ksh


#                     1  Verifica que el watchdogVerificador.ksh
#                               Si no está corriendo, lo inicia. 
#                               Se fija si el pid del watchdogVerificador es el mismo que en el file , si no lo es , corre. 
# Mar 12, 2019
###################################################
#Settings 
porcentageOfTime=0.5
pidFile="./var/watchdogVerificador.pid"
scriptName="watchdogVerificador.ksh"

if [  -f  $pidFile ]; then

    pidValue=`cat $pidFile`

    wdPresent=`ps -eo pid,cmd | grep $pidValue |grep $scriptName | wc -l`

     echo "el valor de wdPresent es $wdPresent"
if [[  "$wdPresent" = 1  ]]; then
        echo "Script is already running"
        exit 0   
    fi
else 
    if [ ! -d "./var" ]; then
        mkdir var
    fi
fi

echo "Script was not running. Initializing script"
(nohup ksh $scriptName > ./var/watchdog.out 2>./var/watchdog.out) & > /dev/null
