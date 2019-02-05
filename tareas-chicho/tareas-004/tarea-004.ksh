#!/bin/ksh
rv=0
for line  in `ls -r *[0-9]*.txt` ;do
    number=`echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    content=`cat $line`	
    let valor=number-1
    if  [ "$valor" != "$content" ]; then   
        echo "el file $line tiene un error"
        rv=1
    fi 
done
exit $rv
