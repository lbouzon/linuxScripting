#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog - 1 Verify if a pidpid  running. If it was , inform, if it was not run it.   
 

# Feb 19, 2019
###################################################
 

porcentageOfTimeRunnuing = 0.005


result=`ps aux | grep "watchdog.sh" | grep -v "grep" | wc -l`
if [ $result -ge 1 ];then 
    echo "script is already unning"
else 
    echo "script was not running. Initializing script"
    nohup sh ~/linuxScripting/deamon/watchdogScripts/watchdog.sh > salida.out 2>salida.out & 
    echo $! > saveW__pid.txt
    printf "\n"
fi

#Control de tiempo de directoryListchecker
waitTime=0

while true 
do
    sleep $waitTime
    start=$SECONDS
    sleep 5
    ./directoryListChecker
     end=$SECONDS
    elapsed=$((end - start))
    let waitTime=$elapsed/$porcentageofRunning	
done 









#kill the pid that saved when launching. ;

       kill -9 `cat save_pid.tx
`
