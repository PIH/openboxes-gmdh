#ALTER TABLE inventory_snapshot ADD CONSTRAINT inventory_snapshot_key UNIQUE (date,location_id,product_id);
#ALTER TABLE inventory_item_snapshot ADD CONSTRAINT inventory_item_snapshot_key UNIQUE (date,location_id,product_id,inventory_item_id);

#ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_1`;
#ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_2`;
#ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_3`;
#ALTER TABLE `inventory_snapshot` DROP INDEX `product_id`;
#ALTER TABLE `inventory_snapshot` DROP INDEX `location_id`;
#ALTER TABLE `inventory_snapshot` DROP INDEX `inventory_item_id`;
#ALTER TABLE `inventory_snapshot` DROP INDEX `date_idx`;
#ALTER TABLE `dim_product_location` ADD INDEX `product_location_idx` (`product_id`, `location_id`);
#ALTER TABLE `inventory_snapshot` ADD UNIQUE INDEX `inventory_snapshot_idx` (`product_id`, `location_id`, `date`);
#ALTER TABLE `inventory_item_snapshot` ADD UNIQUE INDEX `inventory_item_snapshot_idx` (`product_id`, `location_id`, `date`, `inventory_item_id`);

ALTER TABLE requisition_item ADD FOREIGN KEY (parent_requisition_item_id) REFERENCES requisition_item(id);
ALTER TABLE requisition_item ADD FOREIGN KEY (substitution_item_id) REFERENCES requisition_item(id);
ALTER TABLE requisition_item ADD FOREIGN KEY (modification_item_id) REFERENCES requisition_item(id);
