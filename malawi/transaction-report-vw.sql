CREATE OR REPLACE VIEW transaction_report_vw AS
SELECT      
    transaction.transaction_number,
    transaction_type.transaction_code,
    substr(transaction_type.name, 1, locate('|', transaction_type.name)-1) as transaction_type,
    product.product_code,
    IFNULL(product_group_category.name, category.name) as category,
    product.name as product,
    transaction_date,
    day(transaction_date) as day,
    month(transaction_date) as month,
    year(transaction_date) as year,    
    inventory_location.name as inventory,
    source_location_group.name as source_hub,
    inventory_location.id as source_id,
    inventory_location.name as source,
    source_classification.classification as source_class,
    destination_location_group.name as destination_hub,
    destination.id as destination_id,
    destination.name as destination,
    destination_classification.classification as destination_class,
    transaction_entry.quantity 
from transaction_entry  
join transaction on transaction_entry.transaction_id = transaction.id 
join transaction_type on transaction.transaction_type_id = transaction_type.id 
join inventory on transaction.inventory_id = inventory.id 
join location as inventory_location on inventory_location.inventory_id = inventory.id 
join inventory_item on transaction_entry.inventory_item_id = inventory_item.id 
join product on inventory_item.product_id = product.id 
join category on product.category_id = category.id 
left join location as source on transaction.source_id = source.id 
left join location as destination on transaction.destination_id = destination.id 
left join location_classification as destination_classification on destination_classification.location_id = destination.id
left join location_classification as source_classification on source_classification.location_id = inventory_location.id
left join location_group source_location_group on source_location_group.id = inventory_location.location_group_id
left join location_group destination_location_group on destination_location_group.id = destination.location_group_id
LEFT JOIN product_group_product ON product_group_product.product_id = product.id
LEFT JOIN product_group ON product_group.id = product_group_product.product_group_id
LEFT JOIN category product_group_category ON product_group_category.id = product_group.category_id
WHERE transaction_type.transaction_code = 'DEBIT'
HAVING transaction_type = 'Transfer Out';
