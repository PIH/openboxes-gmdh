#!/bin/bash

USERNAME=openboxes
PASSWORD=openboxes
DATABASE=openboxes

mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source location-classification.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source update-location-classifications.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtimes.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source create-function-get-tags.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source transaction-report-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source latest-inventory-snapshot.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source reorder-point-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source shipment-status.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtime-summary-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source inventory-query-debug-vw.sql;"


