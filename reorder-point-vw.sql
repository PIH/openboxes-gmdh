CREATE OR REPLACE VIEW reorder_point_vw AS
SELECT 
    product.id as product_id,
    product.product_code,
    location.id as location_id,
    location.name as location_name,
    location_group.id as location_group_id,
    location_group.name as location_group,
    inventory_level.min_quantity,
    inventory_level.reorder_quantity,
    inventory_level.max_quantity,
    inventory_level.preferred
FROM inventory_level
INNER JOIN inventory ON inventory_level.inventory_id = inventory.id
INNER JOIN product ON product.id = inventory_level.product_id
INNER JOIN location ON location.inventory_id = inventory.id
INNER JOIN location_group ON location.location_group_id = location_group.id
GROUP BY product.id, location.id;


