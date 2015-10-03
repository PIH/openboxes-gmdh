ALTER TABLE inventory_snapshot ADD CONSTRAINT inventory_snapshot_key UNIQUE (date,location_id,product_id);
ALTER TABLE inventory_item_snapshot ADD CONSTRAINT inventory_item_snapshot_key UNIQUE (date,location_id,product_id,inventory_item_id);
