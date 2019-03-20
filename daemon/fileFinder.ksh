#!/bin/ksh
###################################################
# Written By: Lisandro Bouzon Filename: fileFinder.ksh
# Purpose: File getter -    
#                       1  le paso el directorio y me devuelve el file que tiene guardado 
# March 18, 2019
###################################################
dir="$1"
fileList="./bar/listOfFiles.txt"


##########     listOfFiles.txt example   #####################
# dir           fileName
# /home/fakeDir randomName

if [ !  -f  $fileList ];then
    touch $fileList
fi

lineWithDir=`grep "$dir " $fileList`

if [ -z "$lineWithDir" ];then
     name=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 20; date +"%Y%m%d%M%s" `
     echo "$dir $name" >> $fileList
     touch "./bar/${name}"
else  
     name=`echo "$lineWithDir" | cut -d ' ' -f 2`
fi
echo "./bar/${name}"



# Replace lines with logrotate
# logList=(`ls ./bar/*.log`)

#for file in ${logList[@]}; do
#    tail -F -n 100  "${file}" > "${file}.tmp" --retry 
#    mv -f "${file}.tmp" "${file}"
#done



