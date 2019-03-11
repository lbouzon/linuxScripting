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
porcentageOfTime=0.5
pidFile="./var/watchdog.pid"
scriptName="watchdogVerificador.ksh"


if [  -f  $pidFile ];then
    pidfValue=`cat $pidFile`
    namePid=`ps -p $pdifValue -o comm=`
    if [ $namePid = $scriptName ] 
        echo "Script is already running"
        exit 0   
    fi
else 
    if [ ! -d "./var" ]; then
        mkdir var
    fi
fi

echo "Script was not running. Initializing script"
(nohup sh $scriptName > ./var/salidaW.out 2>./var/salidaW.out) & > /dev/null
