#!/bin/bash -vx

echo $SCRIPT_HOME
cd $SCRIPT_HOME

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

# These variables are actually set within the custom setenv.sh
MAIL=jcm62@columbia.edu,justin.miranda@gmail.com
TODAY=`date +%Y-%m-%d`
DATABASE=openboxes

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"
mysql --database="$DATABASE" --execute="source destroy-gmdh-database.sql;"
