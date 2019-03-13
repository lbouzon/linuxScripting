#!/usr/bin/ksh 

psql -c "select * from pg_catalog.pg_tables where schemaname='public'" -d shelltest001 -U shell > direc.txt



