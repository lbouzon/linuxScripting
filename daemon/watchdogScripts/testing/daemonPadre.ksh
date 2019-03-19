#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: daemonPadre.ksh
# Purpose: daemon  -    
#                       1  Deamon que inicializa un deamon por cada directorio a controlar. 
#                       2  Los revive si alguno llega a carse. 
#           			  	2b. Los deamons se llaman fakeDaemon.ksh:
# March 19, 2019
###################################################

daemonSonPids="./bar/daemonSon.pids"
daemonSonPidsTmp="./bar/daemonSon.pids.tmp"

porcentageOfTime=0.05
waitTime=1
daemonSonScript="fakeDaemon.ksh"
daemonOutFile="./bar/salid.out"

alias deamonCmd='(nohup ksh $daemonSonScript $directory > $daemonOutFile.$count 2> $daemonOutFile.$count ) & > /dev/null'

#Delete Lista de Deamons al ser inicializado 

if [ ! -d "./bar" ]; then
    mkdir bar
fi

#*___Quitar el comentario si quieres que se borre el fil de pids._______________________________________
#*  if [ -f "$daemonSonPids" ]; then
#*    longame="$( date +"%Y%m%d%s" )"
#*    mv $daemonSonPids ${daemonSonPids}.${longame}
#*  fi
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
        set -A indice
        for  lineNum in {0..$(($premaxj-1))} ; do
            present=`ps aux | grep "${prePids[$lineNum]}" | grep "$daemonSonScript" | grep "${preList[$lineNum]}" | wc -l`

            # ps aux | grep "${runningPids[$lineNum]}" | grep "$daemonSonScript" | grep "${runningList[$lineNum]}" 

            if [[ "$present" = 0  ]]; then
                # sed -i.bak."`date '+%Y-%m-%d.%H.%M.%S'`" '\=${runningList[$lineNum]} ${runningPids[$lineNum]}=d' $daemonSonPids
                indice+=(`echo $(($lineNum+1))`)
                # sed -i "\=${runningList[$lineNum]} ${runningPids[$lineNum]}=d" $daemonSonPids
            fi
        done

        indice=(`echo ${indice[@]} | rev`)
        for numero in ${indice[@]};
        do
            sed -i.bak "${numero}d" $daemonSonPids
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
               dirsToRun+=("${directories_to_check[$a]}")
            done
        fi

        if  [[ $i -eq $maxi && $j -lt $maxj ]] ;then
            for b in {$j..$ol}; do
                pidsToKill+=("${runningPids[$b]}")
            done
        fi
    else 

        dirsToRun=("${directories_to_check[@]}")

    fi

    #________________________________________________________________________________________________
    # Corre y mata los deamons con sus directorios

    if  [[  "${#pidsToKill[@]}" > 0  ]];then
        for pid in ${pidsToKill[@]}; do
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