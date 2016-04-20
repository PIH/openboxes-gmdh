/**
 *
 * PAP: Please add quantities in incoming shipments with status ‘shipped’ between the following locations to the ‘On Hand’ calculation.
 *  - Bureau Fleriot -> Log Center
 *  - Log Center -> Bureau Fleriot
 *  - HUM Depot 1 -> Log Center
 *  - HUM Depot 1 -> Bureau Fleriot
 */
CREATE OR REPLACE VIEW pap_pending_inventory_vw AS
  SELECT product.product_code, sum(shipment_item.quantity) as quantity
  FROM shipment_status
  JOIN shipment on shipment.id = shipment_status.shipment_id
  JOIN shipment_item on shipment_item.shipment_id = shipment.id
  JOIN product on shipment_item.product_id = product.id
  WHERE (
    (destination = 'Log Center' AND origin IN ('HUM Depot 1 (Picking)', 'Bureau Fleriot PAP')) OR
    (destination = 'Bureau Fleriot PAP' AND origin IN ('HUM Depot 1 (Picking)', 'Log Center'))
  )
  and status like '%Shipped%'
  and status not like '%Received%'
  group by product.product_code;