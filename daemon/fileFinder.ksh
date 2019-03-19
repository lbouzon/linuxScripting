#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: fileFinder.ksh
# Purpose: File getter -    
#                       1  le paso el directorio y me devuelve el file que tiene guardado 
# March 18, 2019
###################################################
dir="$1"
fileList="./bar/listOfFiles.txt"


##########./bar/listOfFiles.txt#####################
# dir           fileName
# /home/fakeDir randomName.list

if [ !  -f  $fileList ];then
    touch $fileList
fi

lineWithDir=`grep "$dir " $fileList`

if [ -z "$lineWithDir" ];then
     name=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 20`
     echo "$dir $name" >> $fileList
     touch "./bar/${name}"
else  
     name=`echo "$lineWithDir" | cut -d ' ' -f 2`
fi
echo "./bar/${name}"