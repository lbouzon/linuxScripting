#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: daemonPadre.ksh
# Purpose: Watchdog -    

#                       1  deamon que inicializa los Deamonshijos de cada directorio
#                       2  Genera la lista de deamons que verifica cada directorio
#			  	2b. Los deamons se llaman directorycheck:
# March 12, 2019
###################################################
 
daemonSonPids="./var/daemonSon.pids"
daemonSonPidsTmp="./var/daemonSon.pids.tmp"

porcentageOfTime=0.05
waitTime=0
daemonSonScript="fakeDaemon.ksh"
daemonOutFile="./var/salid.out"

alias deamonCmd='(nohup ksh $daemonSonScript $directory >$daemonOutFile.$count 2 >$daemonOutFile.$count )  & > /dev/null'
#alias killCmd='grep $directory $daemonSonPids | cut -d ' ' -f  2 | kill -15'



#Delete Lista de Deamons al ser inicializado 

if [ -f $daemonSondPids ]; then

    rm $daemonSonPids

fi

#contador para crearfiles de salida del nohup
count=0



#####################################
#                                   #
# Inicio del deamon.                #
#####################################
while true
do
   
  # Inicio del Calculo de espera de  corrida
    sleep $waitTime
    start=$SECONDS
  #                                         #
   
   
    set -A dirsToKill
    set -A dirsToRun
    set -A dirsToLeave
    directories_to_check=(`psql -q -A -t -c "select directory from directories where username='lbouzon'and enabled=true" -d shelltest001 -U shell | sort`)

   if [ -f ${daemonSondPids} ]; then
    echo "El file $daemonSonPids existe y tiene esto:"
    cat $daemonSonPids 
        runningList=(`cut -d ' ' -f 1  $daemonSonPids`)
        runningPids=(`cut -d ' ' -f 2  $daemonSonPids`)

        i=0
        j=0
        maxi=${#directories_to_check[@]}   
        maxj=${#runningLis[@]}   
        while [[ $j -lt $maxj  &&   $i -lt $maxi   ]]  ;do
            if [[ ${directories_to_check[i]} > ${runningList[j]} ]] ;then
                dirsToKill+="${runningList[j]}"
                pidsToKill+="${runningPids[j]}"

                echo "directorio to Kill ${dirsToKill[j]}"
                echo "pid to Kill ${pidsToKill[j]}"

                let j++

            elif  [[  ${directories_to_check[i]} < ${runningList[j]} ]];then
                
                dirsToRun+="${directories_to_check[i]}"
                echo "dirs to run ${dirsToRun[j]}"

            elif   [[  ${directories_to_check[i]} = ${runningList[j]} ]];then
                    ${directories_to_check[i]} 
                
                 sed -n '${j}p' $daemonSonPids >> $daemonSonPidsTmp 

                let i++
            else
            let j++
            let i++
        fi

        done

    else 
        dirsToRun=$directories_to_check
    fi

    let nl=$maxi-1
    let ol=$maxj-1
    
    if  [[ $j -eq $maxj && $i -lt $maxi ]] ; then
        for a in {$i..$nl}; do
            dirsToKill+="${runningList[j]}"
            pidsToKill+="${runningPids[a]}"
        done
    fi
    if  [[ $i -eq $maxi && $j -lt $maxj ]] ;then
        for b in {$j..$ol}; do
            dirsToRun+="${directories_to_check[i]}"
        done
    fi
                                       

    #Obtengo la lista de directorios
    #qttyDirectories=${#directories_to_check[@]}
    
    rm $daemonSonPids

   # for directory in ${dirsToKill[@]}; do
     for pid in ${pidsToKill[@]}; do
        #killCmd
        kill -15 $pid 
    done

    for directory in ${dirsToRun[@]}; do
        echo "El directorio es $directory"
        echo "el deamonHijo es $daemonSonScript"
        echo "el valor de i es $count"
        echo "el valor de file es $daemonOutFile.$count"
        count=$(($count+1))

        deamonCmd
        
    echo $directory $! >> $daemonSonPids
    done
    cat $daemonSonPidsTmp >> $daemonSonPids

    #Waiter
    end=$SECONDS
    elapsed=$((end - start))
    echo "el valor de Count es $count"
    echo "let´s wait $waitTime"


    if [[ "$elapsed" = 0 ]]; then
        elapsed=1
    fi
    let waitTime=$(($elapsed/$porcentageOfTime))
    
    if [[ "$waitTime" < 1 ]]; then
        waitTime=1
    fi
done
