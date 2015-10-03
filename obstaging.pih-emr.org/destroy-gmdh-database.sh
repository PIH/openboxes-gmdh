#!/bin/bash -x

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

# These variables are actually set within the custom setenv.sh
USERNAME=openboxes
PASSWORD=openboxes
DATABASE=openboxes
MAIL=jcm62@columbia.edu,justin.miranda@gmail.com
TODAY=`date +%Y%m%d`

# Hack to make sure
echo Setting environment variables
cd $HOME/git/openboxes-gmdh/obstaging.pih-emr.org
if [ -f setenv.sh ]; then
  echo Setting custom environment variables
  . setenv.sh
fi

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source destroy-gmdh-database.sql;"
