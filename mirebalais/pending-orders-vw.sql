/**
 * Quantities shipped (not yet received) from vendor to HUM Depot 1
 * Quantities pending (not yet shipped) from vendor to HUM Depot 1
 * Quantities shipped (not yet received) from Boston to HUM Depot 1
 * Quantities shipped (not yet received) from Log Center to HUM Depot 1
 * Quantities shipped (not yet received) from Miami to HUM Depot 1
 * I don’t think we ever send things direct to HUM from Miami but just in case
 * DO NOT include quantities pending (not yet shipped from Miami to HUM Depot 1
 */
CREATE OR REPLACE VIEW hum_pending_orders_vw AS
  SELECT
      product.product_code,
      SUM(shipment_item.quantity) as quantity
  FROM shipment_item
  JOIN shipment ON shipment.id = shipment_item.shipment_id
  JOIN shipment_status ON shipment.id = shipment_status.shipment_id
  JOIN product ON shipment_item.product_id = product.id
  WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin = 'Miami Warehouse' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston Headquarters' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Log Center' AND shipment_status.destination = 'HUM Depot 1 (Picking)' AND shipment_status.status = 'Shipped')
  GROUP BY product.product_code;