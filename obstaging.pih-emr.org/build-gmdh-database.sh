#!/bin/bash 

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

# These variables are actually set within the custom setenv.sh
MAILTO=justin.miranda@gmail.com
TODAY=`date +%Y-%m-%d`
DATABASE=openboxes

# The cron process needs to change directories to find the bash and SQL files
# e.g. SCRIPT_HOME=~/openboxes-gmdh/obstaging.pih-emr.org
echo $SCRIPT_HOME
cd $SCRIPT_HOME
echo `pwd`

# Destroy all GMDH objects (views, functions, tables) before we recreate them
. destroy-gmdh-database.sh

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"

# Update location classification
mysql --database="$DATABASE" --execute="source location-classification.sql;"
mysql --database="$DATABASE" --execute="source update-location-classifications.sql;"

# Create and populate leadtime table
# NOTE: If you enncounter the following error you need to configure apparmor (https://stackoverflow.com/questions/4215231/load-data-infile-error-code-13/13677611#13677611).
# ERROR 29 (HY000) at line 1: File '/home/jmiranda/git/openboxes-gmdh/obstaging.pih-emr.org/leadtimes.csv' not found (Errcode: 13 - Permission denied)
mysql --database="$DATABASE" --execute="source leadtimes.sql;"
cp -f $SCRIPT_HOME/leadtimes.csv /tmp/leadtimes.csv
mysql --database="$DATABASE" --execute="LOAD DATA INFILE '/tmp/leadtimes.csv' REPLACE INTO TABLE leadtime FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"

# Create functions

if ! mysql --database="$DATABASE" --execute="show create function GetTags"; then
  mysql --database="$DATABASE" --execute="source create-function-get-tags.sql;"
fi

# Create dimension tables
mysql --database="$DATABASE" --execute="source create-product-location-dimension.sql;"

# Create views
mysql --database="$DATABASE" --execute="source transaction-report-vw.sql;"
mysql --database="$DATABASE" --execute="source requisition-report-vw.sql;"
mysql --database="$DATABASE" --execute="source reorder-point-vw.sql;"
mysql --database="$DATABASE" --execute="source shipment-status.sql;"
mysql --database="$DATABASE" --execute="source mirebalais/pending-orders-vw.sql;"
mysql --database="$DATABASE" --execute="source mirebalais/pending-inventory-vw.sql;"
mysql --database="$DATABASE" --execute="source port-au-prince/pending-orders-vw.sql;"
mysql --database="$DATABASE" --execute="source port-au-prince/pending-inventory-vw.sql;"
mysql --database="$DATABASE" --execute="source sierra-leone/pending-orders-vw.sql;"
mysql --database="$DATABASE" --execute="source pending-orders-vw.sql;"
mysql --database="$DATABASE" --execute="source pending-inventory-vw.sql;"
mysql --database="$DATABASE" --execute="source leadtime-summary-vw.sql;"
mysql --database="$DATABASE" --execute="source leadtime-summary-mv.sql;"

# Create unique index (will be replaced by OB change soon)
mysql --database="$DATABASE" --execute="source create-indexes.sql;"

echo "Sending notification email to admins $MAIL"
mailx -s "GMDH refresh: Successfully executed nightly GMDH scripts on obstaging.pih-emr.org $TODAY" "$MAILTO" < $LOGFILE
rm $LOGFILE
