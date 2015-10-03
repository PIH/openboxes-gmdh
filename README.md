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
