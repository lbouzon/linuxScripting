#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: fileFinder.ksh
# Purpose: daemon -    
#                       1  deemon que verifica cada cierto tiempo los cambios de un directorio
# March 18, 2019
###################################################
waitTime=0
porcentageOfTime=0.05
while true
do
 # Calculo de espera de  corrida
    sleep $waitTime
    sleep 1 
    start=$SECONDS
    
    file=`./fileFinder.ksh $1`
    ./ChangeControler.ksh $1 $file
    
# Calculo de tiempo de corrida
    end=$SECONDS
    elapsed=$((end - start))

    if [[ "$elapsed" = 0 ]]; then
        elapsed=1
    fi
    let waitTime=$(($elapsed/$porcentageOfTime))

    if [[ "$waitTime" < 1 ]]; then
        waitTime=1
    fi

done
