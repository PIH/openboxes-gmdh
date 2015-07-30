CREATE OR REPLACE VIEW gmdh_inventory_vw AS
SELECT product_id, location_id, MAX(date) AS maxdate
FROM inventory_snapshot
GROUP BY product_id, location_id;

CREATE OR REPLACE VIEW gmdh_miami_inventory_vw AS
SELECT
  product.product_code as product_code,
  GREATEST(inventory_snapshot.quantity_on_hand, 0) AS quantity
FROM inventory_snapshot 
INNER JOIN product ON inventory_snapshot .product_id = product.id
INNER JOIN location ON inventory_snapshot .location_id = location.id
INNER JOIN location_group ON location_group.id = location.location_group_id
INNER JOIN location_type ON location_type.id = location.location_type_id
INNER JOIN gmdh_inventory_vw AS is2 ON inventory_snapshot.location_id = is2.location_id AND inventory_snapshot.product_id = is2.product_id AND inventory_snapshot.date = maxdate
WHERE location.name = 'Miami Warehouse'
GROUP BY inventory_snapshot.product_id, inventory_snapshot.location_id;

CREATE OR REPLACE VIEW gmdh_pending_orders_vw AS
SELECT 
    product_code,
    SUM(quantity) as quantity
FROM shipment_item
JOIN shipment ON shipment.id = shipment_item.shipment_id
JOIN shipment_status ON shipment.id = shipment_status.shipment_id
JOIN product ON shipment_item.product_id = product.id
WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Miami Warehouse' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL)) 
OR (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Log Center' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL)) 
OR (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL)) 
OR (shipment_status.origin = 'Miami Warehouse' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped') 
OR (shipment_status.origin = 'Miami Warehouse' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped') 
GROUP BY product.product_code

UNION ALL 

SELECT product_code, quantity FROM gmdh_miami_inventory_vw;

