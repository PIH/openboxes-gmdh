CREATE TABLE dim_product_location
SELECT product.id AS product_id, location.id AS location_id
FROM product, location;

ALTER TABLE `dim_product_location` ADD INDEX `product_location_idx` (`product_id`, `location_id`);
ALTER TABLE `inventory_snapshot` ADD INDEX `inventory_snapshot_idx` (`product_id`, `location_id`);

ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_1`;
ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_2`;
ALTER TABLE `inventory_snapshot` DROP FOREIGN KEY `inventory_snapshot_ibfk_3`;
ALTER TABLE `inventory_snapshot` DROP INDEX `product_id`;
ALTER TABLE `inventory_snapshot` DROP INDEX `location_id`;
