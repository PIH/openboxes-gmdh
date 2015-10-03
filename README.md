# openboxes-gmdh
Source code used to build GMDH summary data tables and views from an OpenBoxes source database

The following SQL files should be executed (in order) before running the inventory, main, or replacements queries under 
each respective project:

* location_classification.sql
* transaction-report-vw.sql
* latest-inventory-snapshot.sql
* reorder-point-vw.sql
* shipment-status.sql
* pending-orders-vw.sql
* create-function-get-tags.sql
* leadtime-summary-vw.sql
* inventory-query-debug-vw.sql

## crontab
If using cron to send the status update email, you'll need to add a .my.cnf to the crontab user's home directory (~/.my.cnf).
```
[client]
user=openboxes
password=openboxes
```
Also, you may need to specify the SCRIPT_HOME under in your crontab to point to the right directory.

## build-gmdh-database.sh
* Set SCRIPT_HOME in cron
* Enable file permission in order to load from CSV
```
grant file on *.* to 'openboxes'@'localhost';
```

## Importing data into leadtime table
If you enncounter the following error you need to configure apparmor to allow MySQL to import from the
/tmp directory (see https://stackoverflow.com/questions/4215231/load-data-infile-error-code-13/13677611#13677611).
```
ERROR 29 (HY000) at line 1: File '/path/to/openboxes-gmdh/obstaging.pih-emr.org/leadtimes.csv' not found (Errcode: 13 - Permission denied)
```
