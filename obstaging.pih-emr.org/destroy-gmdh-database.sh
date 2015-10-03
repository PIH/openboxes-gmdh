#!/bin/bash -x

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

# These variables are actually set within the custom setenv.sh
MAIL=jcm62@columbia.edu,justin.miranda@gmail.com
TODAY=`date +%Y-%m-%d`
DATABASE=openboxes

cd $SCRIPT_HOME

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"
mysql --database="$DATABASE" --execute="source destroy-gmdh-database.sql;"
