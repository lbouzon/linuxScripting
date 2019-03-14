#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: daemonPadre.ksh
# Purpose: Watchdog -    

#                       1  deamon que inicializa los Deamonshijos de cada directorio
#                       2  Genera la lista de deamons que verifica cada directorio
#			  	2b. Los deamons se llaman directorycheck:
# March 12, 2019
###################################################

daemonSonPids="./bar/daemonSon.pids"
daemonSonPidsTmp="./bar/daemonSon.pids.tmp"

porcentageOfTime=0.5
waitTime=5
daemonSonScript="fakeDaemon.ksh"
daemonOutFile="./bar/salid.out"

alias deamonCmd='(nohup ksh $daemonSonScript $directory > $daemonOutFile.$count 2> $daemonOutFile.$count ) & > /dev/null'

#Delete Lista de Deamons al ser inicializado 

if [ ! -d "./bar" ]; then
    mkdir bar
fi

if [ -f "$daemonSonPids" ]; then
    longame="$( date +"%Y%m%d%s" )"
    mv $daemonSonPids ${daemonSonPids}.${longame}

fi
#________________________________________________________________________________________________

#Contador para crearfiles de salida del nohup
count=0

#####################################
#                                   #
# Inicio del deamon.                #
#####################################

while true
do
    # Calculo de espera de  corrida
    sleep $waitTime
    sleep 1 

    start=$SECONDS

    set -A dirsToRun
    set -A dirsToLeave
    set -A pidsToKill

    #________________________________________________________________________________________________
    # Query para ver los directorios a verificar
    directories_to_check=(`psql -q -A -t -c "select directory from directories where username='lbouzon'and enabled=true" -d shelltest001 -U shell | sort`)

    if [ -f "$daemonSonPids" ]; then

        cat "${daemonSonPids}" 

        #________________________________________________________________________________________________
        #   Verificar si los pids corriendo tiene efectivamente el fakeDeamon corriendo con el direcotorio. 
        #               1. Si es asi, dejadlo en el file $daemonSonPids
        #               2. Si no es asi, borradlo del file. 
        # Si es borrado al comparar
        
        preList=(`cut -d ' ' -f 1  $daemonSonPids`)
        prePids=(`cut -d ' ' -f 2  $daemonSonPids`)

        premaxj=${#preList[@]}   

        for  lineNum in {0..$(($premaxj-1))} ; do
            present=`ps aux | grep "${prePids[$lineNum]}" | grep "$daemonSonScript" | grep "${preList[$lineNum]}" | wc -l`
            echo "Present vale:  $present ."
            echo "El pid es ${prePids[$lineNum]} ,  el script  $daemonSonScript y el directorio es  ${preList[$lineNum]}"

            # ps aux | grep "${runningPids[$lineNum]}" | grep "$daemonSonScript" | grep "${runningList[$lineNum]}" 
            echo ""
            sleep 1

            if [[ "$present" = 0  ]]; then
                #                sed -i.bak."`date '+%Y-%m-%d.%H.%M.%S'`" '\=${runningList[$lineNum]} ${runningPids[$lineNum]}=d' $daemonSonPids
                echo "borraremos ${preList[$lineNum]} ${prePids[$lineNum]}"
                 sed -i "\=${runningList[$lineNum]} ${runningPids[$lineNum]}=d" $daemonSonPids
               # linesvalor=$(($lineNum+1))
                #sed -i "${linesvalor}d" $daemonSonPids
                echo "New file $daemonSonPids tiene:"
                cat "$daemonSonPids"

            fi
        done

        runningList=(`cut -d ' ' -f 1  $daemonSonPids`)
        runningPids=(`cut -d ' ' -f 2  $daemonSonPids`)

        i=0
        j=0

        maxi=${#directories_to_check[@]}   
        maxj=${#runningList[@]}   

        #________________________________________________________________________________________________
        # se fija si los directorios estan corriendo , y sino los agrega a un arra
        # si los directorios estan corriendo pero no están en la lista de correr, los agrega al file de correr. 
        while [[ $j < $maxj  &&   $i < $maxi   ]]  ;do

            if [[ ${directories_to_check[$i]} > ${runningList[$j]} ]] ;then

                pidsToKill+=("${runningPids[$j]}")

                let j++

            elif  [[  ${directories_to_check[$i]} < ${runningList[$j]} ]];then

                dirsToRun+=("${directories_to_check[$i]}")

                let i++

            elif   [[  ${directories_to_check[$i]} = ${runningList[$j]} ]];then

                let i++
                let j++

                sed -n "${j}p" "$daemonSonPids" >> "$daemonSonPidsTmp"

            fi

        done

        rm $daemonSonPids

        let nl=$maxi-1
        let ol=$maxj-1

        if  [[ $j -eq $maxj && $i -lt $maxi ]] ; then
            for a in {$i..$nl}; do
                pidsToKill+=("${runningPids[$a]}")
            done
        fi

        if  [[ $i -eq $maxi && $j -lt $maxj ]] ;then
            for b in {$j..$ol}; do
                dirsToRun+=("${directories_to_check[$b]}")
            done
        fi
    else 

        dirsToRun=("${directories_to_check[@]}")

    fi

    #________________________________________________________________________________________________
    # Corre y mata los deamons con sus directorios
    echo "Hay ${#pidsToKill[@]} pids to Kill"
    echo "Los pids son: ${pidsToKill[@]}"


    echo "Hay ${#dirsToRun[@]} dirs to run "
    echo "Los dirs son ${dirsToRun[@]}"

    if  [[  "${#pidsToKill[@]}" > 0  ]];then
        for pid in ${pidsToKill[@]}; do
            #killCmd
            kill -15 $pid 
        done
    fi

    if [[ "${#dirsToRun[@]}" > 0  ]];then

        for directory in ${dirsToRun[@]}; do
            count=$(($count+1))

            deamonCmd

            echo "$directory" "$!" >> "$daemonSonPidsTmp"
        done
    fi    

    cat "$daemonSonPidsTmp" | sort >> "$daemonSonPids"
    rm "$daemonSonPidsTmp"  

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
