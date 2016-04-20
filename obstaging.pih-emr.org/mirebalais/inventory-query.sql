SELECT
	CONCAT(IFNULL(product_group_category.name, category.name), '::', product.product_code) AS cat_code,
	product.name,
	IFNULL(GREATEST(SUM(inventory_snapshot.quantity_on_hand), 0), 0) +
  	IFNULL(pending_inventory_vw.quantity, 0) AS qty,
	IFNULL(leadtime_summary_vw.lead_time_in_days, 0),
	IFNULL(pending_orders_vw.quantity, 0),
	NULL, NULL, NULL,
	GetTags(product.product_code)
FROM dim_product_location
LEFT OUTER JOIN inventory_snapshot ON (dim_product_location.product_id = inventory_snapshot.product_id
	AND dim_product_location.location_id = inventory_snapshot.location_id
	AND inventory_snapshot.date = (SELECT max(date) FROM inventory_snapshot))
INNER JOIN location on location.id = dim_product_location.location_id
INNER JOIN location_group on location.location_group_id = location_group.id
INNER JOIN product on product.id = dim_product_location.product_id
INNER JOIN category ON product.category_id = category.id
LEFT OUTER JOIN location_classification ON location_classification.location_id = location.id
LEFT OUTER JOIN leadtime_summary_vw ON (product.product_code = leadtime_summary_vw.product_code AND leadtime_summary_vw.project = 'Haiti HUM Project')
LEFT OUTER JOIN product_group_product ON product_group_product.product_id = product.id
LEFT OUTER JOIN product_group ON product_group.id = product_group_product.product_group_id
LEFT OUTER JOIN category product_group_category ON product_group_category.id = product_group.category_id
LEFT OUTER JOIN pending_orders_vw ON (product.product_code = pending_orders_vw.product_code and pending_orders_vw.location_group = 'Mirebalais')
LEFT OUTER JOIN pending_inventory_vw ON (product.product_code = pending_orders_vw.product_code and pending_orders_vw.location_group = 'Mirebalais')
WHERE location_classification.classification IN ('Level 2')
AND location_group.name = 'Mirebalais'
GROUP BY product.id;
