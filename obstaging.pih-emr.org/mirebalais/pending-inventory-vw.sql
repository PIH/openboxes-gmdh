/*
 * HUM: Please add quantities in incoming shipments with status ‘shipped’ between the following locations to the ‘On Hand’ calculation.
 *  - Log Center -> HUM Depot 1
 *  - Bureau Fleriot -> HUM Depot 1
 */
CREATE OR REPLACE VIEW hum_pending_inventory_vw AS
  SELECT product.product_code, sum(shipment_item.quantity) as quantity
  FROM shipment_status
  JOIN shipment on shipment.id = shipment_status.shipment_id
  JOIN shipment_item on shipment_item.shipment_id = shipment.id
  JOIN product on shipment_item.product_id = product.id
  WHERE (destination = 'HUM Depot 1 (Picking)' AND origin IN ('Log Center', 'Bureau Fleriot PAP'))
  and status like '%Shipped%'
  and status not like '%Received%'
  group by product.product_code;