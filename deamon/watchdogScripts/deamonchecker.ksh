#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon
# Purpose: Watchdog - 1 Verify if a pidpid  running. If it was , inform, if it was not run it.   
 

# Feb 19, 2019
###################################################
 

result=`ps aux | grep "minutetrackerD.sh" | grep -v "grep" | wc -l`
if [ $result -ge 1 ];then 
    echo "script is already unning"
else 
    echo "script was not running. Initializing script"
    nohup sh ~/linuxScripting/deamon/nohupEx/minutetrackerD.sh > salida.out 2>salida.out & 
    echo $! > save_pid.txt

    printf "\n"
fi

#kill the pid that saved when launching. ;
       kill -9 `cat save_pid.txt`
