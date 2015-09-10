/**

 * Quantity on hand in Miami Warehouse
 * Quantity on hand in Boston HQ: Haiti Stock
 * Quantities shipped (not yet received) from vendor to Miami Warehouse: Haiti Stock
 * Quantities pending (not yet shipped) from vendor to Miami Warehouse: Haiti Stock
 * Quantities shipped (not yet received) from vendor to Boston HQ: Haiti Stock
 * Quantities pending (not yet shipped) from vendor to Boston HQ: Haiti Stock
 * Quantities shipped (not yet received) from vendor to Log Center
 * Quantities pending (not yet shipped) from vendor to Log Center
 * Quantities shipped (not yet received) from Miami Warehouse: Haiti Stock to Log Center
 * Quantities shipped (not yet received) from Boston HQ: Haiti Stock to Log Center
 * Quantities shipped (not yet received) from Boston HQ: Haiti Stock to Miami Warehouse: Haiti Stock
 * DO NOT include quantities pending (not yet shipped) from Miami to Log Center
 */
CREATE OR REPLACE VIEW miami_inventory_snapshot_vw AS
  SELECT
    product.product_code as product_code,
    GREATEST(SUM(inventory_snapshot.quantity_on_hand), 0) AS quantity
  FROM inventory_snapshot
  INNER JOIN product ON inventory_snapshot.product_id = product.id
  INNER JOIN location ON inventory_snapshot.location_id = location.id
  INNER JOIN location_group ON location_group.id = location.location_group_id
  INNER JOIN location_type ON location_type.id = location.location_type_id
  INNER JOIN latest_inventory_snapshot AS is2 ON inventory_snapshot.location_id = is2.location_id AND inventory_snapshot.product_id = is2.product_id AND inventory_snapshot.date = maxdate
  WHERE location.name IN ('Miami Warehouse: Haiti Stock', 'Boston HQ: Haiti Stock')
  GROUP BY inventory_snapshot.product_id;

CREATE OR REPLACE VIEW pap_pending_orders_vw AS
  SELECT
      product.product_code,
      SUM(shipment_item.quantity + miami_inventory_snapshot_vw.quantity) as quantity
  FROM shipment_item
  JOIN shipment ON shipment.id = shipment_item.shipment_id
  JOIN shipment_status ON shipment.id = shipment_status.shipment_id
  JOIN product ON shipment_item.product_id = product.id
  LEFT JOIN miami_inventory_snapshot_vw ON product.product_code = miami_inventory_snapshot_vw.product_code
  WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Miami Warehouse: Haiti Stock' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Miami Warehouse: Haiti Stock' AND shipment_status.status IS NULL)
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Boston HQ: Haiti Stock' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Boston HQ: Haiti Stock' AND shipment_status.status IS NULL)
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Log Center' AND shipment_status.status IS NULL)
  OR    (shipment_status.origin = 'Miami Warehouse: Haiti Stock' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston HQ: Haiti Stock' AND shipment_status.destination = 'Log Center' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston HQ: Haiti Stock' AND shipment_status.destination = 'Miami Warehouse: Haiti Stock' AND shipment_status.status = 'Shipped')
  GROUP BY product.product_code;

