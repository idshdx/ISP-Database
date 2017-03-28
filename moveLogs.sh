# Script used to move rows of a table into another if the count of rows is past a number
# Meant to be used with crontab.
# Example running a the job monthy: 10 0 1 * * /usr/bin/archivelogs.sh -db user -db pass(detailed more below)

#!/bin/sh

DATABASE=Portal   
TARGET_TABLE=Logs
DESTINATION_TABLE=ArchivedLogs

# Set the PGPASSWORD environment variable inside the script before calling psql. 
# Best is to use pgpass for removing the interactive psql password prompt
# reference: https://www.postgresql.org/docs/current/static/libpq-envars.html
# pgpass reference: https://www.postgresql.org/docs/8.2/static/libpq-pgpass.html

PGPASSWORD=$2 psql -U $1 $1 # command line args or you can hardcode

psql -d ${DATABASE} -U $1  -<<THE_END #connect to the db server, begining of sql code

--if moveLogs() is found on the db server, you can use the function instead of the defition below
--SELECT "moveLogs"(); THE_END


DECLARE
count integer;
timespan date;

BEGIN
	count ='SELECT COUNT(id) FROM ${TARGET_TABLE}';
	timespan = 'CURRENT_DATE - INTERVAL $$3 months$$';

 	IF(count > 10000) THEN
  		INSERT INTO ${DESTINATION_TABLE} SELECT * FROM ${TARGET_TABLE} WHERE "createdAt" > timespan;
  		DELETE FROM ${TARGET_TABLE} WHERE "createdAt" > timespan;
 	END IF;
END;
RETURN NULL; --Can be used further like outputting the number of rows moved
LANGUAGE 'plpgsql'
THE_END

echo 'archivelogs.sh: Moved CBS Portal Logs'
