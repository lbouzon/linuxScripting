#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: daemonPadre.ksh
# Purpose: Watchdog -    

#                       1  deamon que inicializa los Deamonshijos de cada directorio
#                       2  Genera la lista de deamons que verifica cada directorio
#			  	2b. Los deamons se llaman directorycheck:
# March 12, 2019
###################################################
 

set porcentageOfTimeRunnuing = 0.05
waitTime=0

while true
do
    sleep $waitTime
    start=$SECONDS
     
 
#Obtengo la lista de directorios
    directories_to_check=(`psql -t -c "select directory from directories where username='lbouzon'and enabled=true" -d shelltest001 -U shell`)
    qttyDirectories=${#directories_to_check[@]}


    for directory in $(directories_to_check); do
         nohup ksh ./deamonDirectory.ksh $directory > salid$!.out 2 > salid$!.out
         echo $directory $! > deamon.list
    done

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

#kill the pid that saved when launching. ;
