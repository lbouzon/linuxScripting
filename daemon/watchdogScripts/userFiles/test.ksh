#!/bin/ksh
pidFile="./bar/watchdog.pid"
name=`basename $0`

if [ -f  $pidFile ];then
    pidValue=`cat $pidFile`
    namePid=`ps -p ${pidValue} -o comm=`
    if [ "$namePid" = "$name" ];then
      echo "script is already running"
      exit 0
    fi
fi



echo "Script was not running"

if [ ! -d "./bar" ]; then
    mkdir bar 
fi

(nohup sh $0 > ./bar/salidaW.out 2>./bar/salidaW.out) & > /dev/null
echo $! > $pidFile



pidfValue=`cat $pidFile`

echo "el valor de pesos! es $! , PIDVALUE ES $pidValue"
echo "el valor de $$"



if [ "$pidValue" = "$$" ] ; then
        exit 0
    fi

while true; do
    sleep 55
    echo "lisa"  > ./bar/output.txt
    sleep 44
done

