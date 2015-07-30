CREATE OR REPLACE VIEW miami_inventory_snapshot_vw AS
SELECT
  product.product_code as product_code,
  GREATEST(inventory_snapshot.quantity_on_hand, 0) AS quantity
FROM inventory_snapshot
INNER JOIN product ON inventory_snapshot .product_id = product.id
INNER JOIN location ON inventory_snapshot .location_id = location.id
INNER JOIN location_group ON location_group.id = location.location_group_id
INNER JOIN location_type ON location_type.id = location.location_type_id
INNER JOIN latest_inventory_snapshot AS is2 ON inventory_snapshot.location_id = is2.location_id AND inventory_snapshot.product_id = is2.product_id AND inventory_snapshot.date = maxdate
WHERE location.name = 'Miami Warehouse'
GROUP BY inventory_snapshot.product_id, inventory_snapshot.location_id;


CREATE OR REPLACE VIEW pending_orders_vw AS
  SELECT
      product.product_code,
      SUM(shipment_item.quantity + miami_inventory_snapshot_vw.quantity) as quantity
  FROM shipment_item
  JOIN shipment ON shipment.id = shipment_item.shipment_id
  JOIN shipment_status ON shipment.id = shipment_status.shipment_id
  JOIN product ON shipment_item.product_id = product.id
  LEFT JOIN miami_inventory_snapshot_vw ON product.product_code = miami_inventory_snapshot_vw.product_code
  WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Miami Warehouse' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Log Center' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin = 'Miami Warehouse' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Miami Warehouse' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston Headquarters' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston Headquarters' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Log Center' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  GROUP BY product.product_code;

