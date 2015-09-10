/**
 * Quantities shipped (not yet received) from vendor to WFP DFID - restricted
 * Quantities shipped (not yet received) from vendor to WFP Main Logistics Hub – Port Loko
 * Quantities shipped (not yet received) from vendor to PIH Office, Freetown
 * Quantities shipped (not yet received) from vendor to Kono Warehouse
 * Quantities shipped (not yet received) from Boston to WFP DFID - restricted
 * Quantities shipped (not yet received) from Boston to WFP Main Logistics Hub – Port Loko
 * Quantities shipped (not yet received) from Boston to PIH Office, Freetown
 * Quantities shipped (not yet received) from Boston to Kono Warehouse
 */
CREATE OR REPLACE VIEW sl_pending_orders_vw AS
  SELECT
      product.product_code,
      SUM(shipment_item.quantity) as quantity
  FROM shipment_item
  JOIN shipment ON shipment.id = shipment_item.shipment_id
  JOIN shipment_status ON shipment.id = shipment_status.shipment_id
  JOIN product ON shipment_item.product_id = product.id
  WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'WFP DFID - restricted' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'PIH Office, Freetown' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'WFP Main Logistics Hub - Port Loko' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Kono Warehouse' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin = 'Boston HQ: SL Stock' AND shipment_status.destination = 'WFP DFID - restricted' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston HQ: SL Stock' AND shipment_status.destination = 'PIH Office, Freetown' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston HQ: SL Stock' AND shipment_status.destination = 'WFP Main Logistics Hub - Port Loko' AND shipment_status.status = 'Shipped')
  OR    (shipment_status.origin = 'Boston HQ: SL Stock' AND shipment_status.destination = 'Kono Warehouse' AND shipment_status.status = 'Shipped')
  GROUP BY product.product_code;

