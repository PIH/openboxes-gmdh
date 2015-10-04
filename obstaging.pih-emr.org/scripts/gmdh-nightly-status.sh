#!/bin/bash

cd "$SCRIPT_HOME"

locations=$(mysql openboxes -ss -e "source find-new-locations.sql;")

products=$(mysql openboxes -ss -e "source find-new-products.sql;")

inventorySnapshot=$(mysql openboxes -ss -e 'select count(*) as count, max(date) from inventory_snapshot\G')

inventoryItemSnapshot=$(mysql openboxes -ss -e 'select count(*) as count, max(date) from inventory_item_snapshot\G')

transactionReportVw=$(mysql openboxes -ss -e 'select count(*) as count from transaction_report_vw\G')

leadtimeSummaryVw=$(mysql openboxes -ss -e 'select project, count(*) as count from leadtime_summary_vw group by project\G')

tables=$(mysql openboxes -ss -e 'show tables\G')

views=$(mysql openboxes -ss -e 'show table status like "%vw%"\G')

productsWithMultipleProductGroups=$(mysql openboxes -ss -e 'select product_code, product.name, count(*) from product_group pg join product_group_product pgp on pgp.product_group_id = pg.id join product on pgp.product_id = product.id group by product.id having count(*) > 1\G')

echo "<html>"
echo "<head>"
echo "</head>"
echo "<body>"
echo "<h1>OpenBoxes GMDH Status Report</h1>"
echo "<h2>inventory_snapshot</h2>"
if [ "$inventorySnapshot" ] 
then
    echo "<pre>$inventorySnapshot</pre>"
else 
    echo "No inventory snapshot data" 
fi


echo "<h2>inventory_item_snapshot</h2>"
if [ "$inventoryItemSnapshot" ] 
then
    echo "<pre>$inventoryItemSnapshot</pre>"
else 
    echo "No inventory item snapshot data" 
fi

echo "<h2>transaction_report_vw</h2>"
if [ "$transactionReportVw" ] 
then
    echo "<pre>$transactionReportVw</pre>"
else 
    echo "No transaction report data" 
fi

echo "<h2>leadtime_summary_vw</h2>"
if [ "$leadtimeSummaryVw" ] 
then
    echo "<pre>$leadtimeSummaryVw</pre>"
else 
    echo "No lead time summary data" 
fi

echo "<h2>New locations (past 7 days):</h2>"
if [ "$locations" ] 
then
    echo "<pre>$locations</pre>"
else 
    echo "No new locations" 
fi

echo "<h2>New products (past 7 days):</h2>"
if [ "$products" ] 
then
    echo "<pre>$products</pre>" 
else 
    echo "No new products"
fi

echo "<h2>Products with multiple product groups:</h2>"
echo "<pre>$productsWithMultipleProductGroups</pre>" 

#echo "<h2>Views:</h2>"
#echo "<pre>$views</pre>" 

#echo "<h2>Tables:</h2>"
#echo "<pre>$tables</pre>" 

echo "</body>"
echo "</html>"
