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

porcentageOfTime=0.05
waitTime=5
daemonSonScript="fakeDaemon.ksh"
daemonOutFile="./bar/salid.out"

alias deamonCmd='(nohup ksh $daemonSonScript $directory > $daemonOutFile.$count 2> $daemonOutFile.$count ) & > /dev/null'
#alias killCmd='grep $directory $daemonSonPids | cut -d ' ' -f  2 | kill -15'



#Delete Lista de Deamons al ser inicializado 


if [ ! -d "./bar" ]; then
#    echo "Creating bar folder"
    mkdir bar
fi

if [ -f "$daemonSonPids" ]; then
    logname="$( date +"%Y%m%d%s" )"
 #   echo "Renaming pids File to $daemonSonPids.$logname"
    mv $daemonSonPids ${daemonSonPids}.${logname}
   
fi

#contador para crearfiles de salida del nohup
count=0
paseo=0


#####################################
#                                   #
# Inicio del deamon.                #
#####################################

while true
do
  #echo "Vuelta: $paseo" 
  # Inicio del Calculo de espera de  corrida
    sleep $waitTime
    sleep 1 



    start=$SECONDS
  #                                         #
   
    set -A dirsToKill
    set -A dirsToRun
    set -A dirsToLeave
    set -A pidsToKill

    directories_to_check=(`psql -q -A -t -c "select directory from directories where username='lbouzon'and enabled=true" -d shelltest001 -U shell | sort`)

   # echo "1)"
   # echo "Los directorios a verificar son ${directories_to_check[@]}"

              

    if [ -f "$daemonSonPids" ]; then


#        echo "El file $daemonSonPids existe y tiene esto:"

        cat "${daemonSonPids}" 
        
#        echo "-___________________fin____________________-"
            
        runningList=(`cut -d ' ' -f 1  $daemonSonPids`)
        runningPids=(`cut -d ' ' -f 2  $daemonSonPids`)

        #rm $daemonSonPids
        i=0
        j=0
        maxi=${#directories_to_check[@]}   
        maxj=${#runningList[@]}   
      

        #aca empieza el error

        while [[ $j < $maxj  &&   $i < $maxi   ]]  ;do

#        echo "el valor de to Check: ${directories_to_check[i]} and to run:  ${runningList[j]}"


            if [[ ${directories_to_check[i]} > ${runningList[j]} ]] ;then
            
                dirsToKill+=("${runningList[j]}")
                pidsToKill+=("${runningPids[j]}")
            
#                echo "directorio to Kill ${dirsToKill[j]}"
#                echo "pid to Kill ${pidsToKill[j]}"
            
                let j++
            
            elif  [[  ${directories_to_check[i]} < ${runningList[j]} ]];then
                    
                dirsToRun+=("${directories_to_check[i]}")
#               echo "dirs to run ${dirsToRun[j]}"
            
            elif   [[  ${directories_to_check[i]} = ${runningList[j]} ]];then
#                echo  "Esté ya está corriendo  ${directories_to_check[i]}"
              
                let i++
                let j++

                sed -n "${j}p" "$daemonSonPids" >> "$daemonSonPidsTmp"
            
            fi
            
       done
    rm $daemonSonPids

  #else 
     #echo "El File $daemonSonPids no existe. Se corren todos entonces"  
     #dirsToRun=("${directories_to_check[@]}")
  #fi

       let nl=$maxi-1
       let ol=$maxj-1
    
       if  [[ $j -eq $maxj && $i -lt $maxi ]] ; then
            for a in {$i..$nl}; do
                dirsToKill+=("${runningList[a]}")
                pidsToKill+=("${runningPids[a]}")
            done
       fi
       
       if  [[ $i -eq $maxi && $j -lt $maxj ]] ;then
            for b in {$j..$ol}; do
                dirsToRun+=("${directories_to_check[b]}")
            done
       fi
     else 
        
#       echo "El File $daemonSonPids no existe. Se corren todos entonces"  
        dirsToRun=("${directories_to_check[@]}")

     fi

                                  
    #Obtengo la lista de directorios
    #qttyDirectories=${#directories_to_check[@]}
    

   # for directory in ${dirsToKill[@]}; do


echo "Hay ${#pidsToKill[@]} pids to Kill"
echo "Hay ${#dirsToRun[@]} dirs to run "

   if  [[  "${#pidsToKill[@]}" > 0  ]];then
        for pid in ${pidsToKill[@]}; do
        #killCmd
            kill -15 $pid 
        done
   fi


    if [[ "${#dirsToRun[@]}" > 0   ]];then

         for directory in ${dirsToRun[@]}; do
            count=$(($count+1))

            deamonCmd
        
           echo "$directory" "$!" >> "$daemonSonPidsTmp"
        done
    fi    

    cat "$daemonSonPidsTmp" >> "$daemonSonPids"
    rm "$daemonSonPidsTmp"  

    #Waiter
    end=$SECONDS
    elapsed=$((end - start))


#    echo "let´s wait $waitTime"


    if [[ "$elapsed" = 0 ]]; then
        elapsed=1
    fi
    let waitTime=$(($elapsed/$porcentageOfTime))
    
    if [[ "$waitTime" < 1 ]]; then
        waitTime=1
    fi
    paseo=$(($paseo+1))

done
