#!/bin/bash
#Deamon que graba en un file el tiempo cada minuto. 

while true ;do 
    date >> filetime.txt
    sleep 55
done

set qFiles='wc -l < filetime.txt'

if ((qFiles > 10)) ; do
    tail -n +2 filetime.txt > filetimeTMP.txt  && mv filetimeTMP.txt  filetime.txt
done 
