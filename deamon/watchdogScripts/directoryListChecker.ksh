
directories_to_check=`psql -c "select directory from directories where username='lbouzon'and  enabled=true " -d shelltest001 -U shell`  | tail -n +3 | head -n -2
echo $directories_to_check 
#list of algo en forma simple
#psql -c "select tablename from pg_catalog.pg_tables where schemaname='public'" -d shelltest001 -U shell | tail -n +3 | head -n -2

directories_running=`cat runningDirectories.list`

#q_to_check=`echo "$directories_to_check" | wc -l `
#q_running=`echo "$directories_running" | wc -l`


diferencia=(`echo ${q_to_check[@]} ${q_running[@]} | tr ' ' '\n' | sort | uniq -u`)

for chequeo in $diferencia 
    if [[ `echo ${directories_running[@]}` =~ `$chequeo` ]] then
        ./directoryChecker $chequeo
    else
         ./directoryKiller $chequeo
fi
