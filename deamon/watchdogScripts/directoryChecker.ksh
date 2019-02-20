
directories=`psql -c "select directory from directories where username='lbouzon'and  enabled=true " -d shelltest001 -U shell`
echo  $directories

#list of algo en forma simple
psql -c "select tablename from pg_catalog.pg_tables where schemaname='public'" -d shelltest001 -U shell | tail -n +3 | head -n -2



run_directories=`cat runningDirectories.list`



dirLines=`echo "$directories" | wc -l `
run_directories=`echo "$run_directories" | wc -l`

for i to direlines
	for j to run_directories
		if line = line


