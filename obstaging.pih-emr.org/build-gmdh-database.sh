#!/bin/bash -x

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

# These variables are actually set within the custom setenv.sh
USERNAME=openboxes
PASSWORD=openboxes
DATABASE=openboxes
MAIL=jcm62@columbia.edu,justin.miranda@gmail.com
TODAY=`date +%Y%m%d`

# The cron process needs to change directories to find the bash and SQL files
# e.g. SCRIPT_HOME=~/openboxes-gmdh/obstaging.pih-emr.org
cd $SCRIPT_HOME

#  Setting other environment variables
if [ -f setenv.sh ]; then
  echo "Setting custom environment variables"
  . setenv.sh
fi

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source location-classification.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source update-location-classifications.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtimes.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source create-function-get-tags.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source transaction-report-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source latest-inventory-snapshot.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source reorder-point-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source shipment-status.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source create-product-location-dimension.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source mirebalais/pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source port-au-prince/pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source sierra-leone/pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtime-summary-vw.sql;"

echo "Sending notification email to admins $MAIL"
mailx -s "GMDH refresh: Successfully executed nightly GMDH scripts on obstaging.pih-emr.org $TODAY" "$MAIL" < $LOGFILE
rm $LOGFILE
