/** 
 * Quantities pending from Boston to Lisungwi Warehouse Main
 * Quantities shipped from Boston to Lisungwi Warehouse Main
 * Quantities pending from Boston to Lisungwi Warehouse TB Care
 * Quantities shipped from Boston to Lisungwi Warehouse TB Care
 * Quantities pending from Boston to Lisungwi Warehouse Cargill
 * Quantities shipped from Boston to Lisungwi Warehouse Cargill
 * Quantities pending from Boston to Lisungwi Warehouse DFID
 * Quantities shipped from Boston to Lisungwi Warehouse DFID
 * Quantities pending from vendor to Lisungwi Warehouse Main
 * Quantities shipped from vendor to Lisungwi Warehouse Main
 * Quantities pending from vendor to Lisungwi Warehouse TB Care
 * Quantities shipped from vendor to Lisungwi Warehouse TB Care
 * Quantities pending from vendor to Lisungwi Warehouse Cargill
 * Quantities shipped from vendor to Lisungwi Warehouse Cargill
 * Quantities pending from vendor to Lisungwi Warehouse DFID
 * Quantities shipped from vendor to Lisungwi Warehouse DFID
 */
CREATE OR REPLACE VIEW pending_orders_vw AS
  SELECT
      product.product_code,
      SUM(shipment_item.quantity) as quantity
  FROM shipment_item
  JOIN shipment ON shipment.id = shipment_item.shipment_id
  JOIN shipment_status ON shipment.id = shipment_status.shipment_id
  JOIN product ON shipment_item.product_id = product.id
  WHERE (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Lisungwi Warehouse Main' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Lisungwi Warehouse TB Care' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Lisungwi Warehouse Cargill' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Supplier' AND shipment_status.destination = 'Lisungwi Warehouse DFID' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Boston Headquarters' AND shipment_status.destination = 'Lisungwi Warehouse Main' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Boston Headquarters' AND shipment_status.destination = 'Lisungwi Warehouse TB Care' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Boston Headquarters' AND shipment_status.destination = 'Lisungwi Warehouse Cargill' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))
  OR    (shipment_status.origin_type = 'Boston Headquarters' AND shipment_status.destination = 'Lisungwi Warehouse DFID' AND (shipment_status.status = 'Shipped' OR shipment_status.status IS NULL))

  GROUP BY product.product_code;

