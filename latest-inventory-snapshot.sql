CREATE OR REPLACE VIEW latest_inventory_snapshot AS
SELECT product_id, location_id, MAX(date) AS maxdate
FROM inventory_snapshot
GROUP BY product_id, location_id;

