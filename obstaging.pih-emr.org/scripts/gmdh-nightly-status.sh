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
echo "Indicates the total number of records as well as the most recent date recorded for the inventory snapshot table. "
echo "NOTE: If you see count = 0 OR max(date) does not equal today's date then there might be a problem." 
if [ "$inventorySnapshot" ] 
then
    echo "<pre>$inventorySnapshot</pre>"
else 
    echo "No inventory snapshot data" 
fi

echo "<h2>inventory_item_snapshot</h2>"
echo "Indicates the total number of records as well as the most recent date recorded for the inventory item snapshot table. "
echo "NOTE: If you see count = 0 OR max(date) does not equal today's date then there might be a problem."
if [ "$inventoryItemSnapshot" ] 
then
    echo "<pre>$inventoryItemSnapshot</pre>"
else 
    echo "No inventory item snapshot data" 
fi

echo "<h2>Consumption data</h2>"
echo "Shows the number of records returned by the consumption view."
if [ "$transactionReportVw" ] 
then
    echo "<pre>$transactionReportVw</pre>"
else 
    echo "No consumption data" 
fi

echo "<h2>leadtime_summary_vw</h2>"
echo "Shows the number of records returned by the leadtime summary view."
if [ "$leadtimeSummaryVw" ] 
then
    echo "<pre>$leadtimeSummaryVw</pre>"
else 
    echo "No lead time summary data" 
fi

echo "<h2>New locations</h2>"
echo "Includes all new locations created in the past 24 hours."
if [ "$locations" ] 
then
    echo "<pre>$locations</pre>"
else 
    echo "No new locations" 
fi

echo "<h2>New products (past 24 hours):</h2>"
echo "Includes all new products created in the past 24 hours."
if [ "$products" ] 
then
    echo "<pre>$products</pre>" 
else 
    echo "No new products"
fi

echo "<h2>Multiple product groups:</h2>"
echo "Includes all products that have been added to multiple product groups."
if [ "$productsWithMultipleProductGroups" ]
then
    echo "<pre>$productsWithMultipleProductGroups</pre>"
else
    echo "No products with multiple product groups"
fi

#echo "<h2>Views:</h2>"
#echo "<pre>$views</pre>" 

#echo "<h2>Tables:</h2>"
#echo "<pre>$tables</pre>" 

echo "</body>"
echo "</html>"
