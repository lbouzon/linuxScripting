#!/bin/ksh
rv=0

if [[ 1 != ${#} ]];then
   echo "Ony 1 argument is accepted" 	
   exit 1
fi


case $1 in 
		+([0-9])*(.)*([0-9]) )
		argument=$1
	;;

	*)
		echo "Argument is not a number"
		exit 1
	;;
esac

ls -r *[0-9]*.txt | while read line ; do
    number=`echo "$line" | sed -re 's/^(.*[^0-9])?([0-9]+)[^0-9]*$/\2/g'`
    content=`cat $line`	
    let valor=number-$1
   if [ "$valor" != $content ]; then   
        echo "el file $line tiene un error"
        rv=1
    fi 
done
exit $rv
