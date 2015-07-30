CREATE OR REPLACE VIEW inventory_query_debug_vw AS
SELECT
    location_group.name as location_group,
    location.name as location,
    product.product_code as product_code,       
    CONCAT(IFNULL(product_group_category.name, category.name), '::', product.product_code) AS cat_code,
    product.name,
    snap.quantity_on_hand,
    leadtime_summary_vw.lead_time_in_days,
    gmdh_pending_orders_vw.quantity,
    NULL, NULL, NULL
FROM product
INNER JOIN category ON product.category_id = category.id
LEFT OUTER JOIN inventory_snapshot AS snap ON snap.product_id = product.ID 
INNER JOIN location ON snap.location_id = location.id
INNER JOIN location_group ON (location_group.id = location.location_group_id AND location_group.name = 'Port au Prince')
INNER JOIN location_type ON (location_type.id = location.location_type_id AND location_type.name LIKE 'Depot%')
INNER JOIN latest_inventory_snapshot AS is2 ON snap.location_id = is2.location_id AND snap.product_id = is2.product_id AND snap.date = maxdate
LEFT OUTER JOIN leadtime_summary_vw ON (product.product_code = leadtime_summary_vw.product_code AND leadtime_summary_vw.project = 'Haiti PAP Project')
LEFT OUTER JOIN reorder_point_vw ON (product.id = reorder_point_vw.product_id AND reorder_point_vw.location_group = 'Port au Prince')
LEFT OUTER JOIN product_group_product ON product_group_product.product_id = product.id
LEFT OUTER JOIN product_group ON product_group.id = product_group_product.product_group_id
LEFT OUTER JOIN category product_group_category ON product_group_category.id = product_group.category_id;
LEFT OUTER JOIN gmdh_pending_orders_vw ON product.product_code = gmdh_pending_orders_vw.product_code;

