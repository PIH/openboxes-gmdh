DROP TABLE IF EXISTS `location_classification`;

CREATE TABLE `location_classification` (
  `location_id` char(38) NOT NULL DEFAULT '',
  `classification` varchar(255) NOT NULL,
  CONSTRAINT `location_id` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  KEY (`classification`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE UNIQUE INDEX location_classification_idx ON location_classification(location_id, classification);

INSERT INTO location_classification(location_id, classification)
SELECT 
    id,  
    CASE location_type_id 
    WHEN 2 THEN 'Level 2' 
    WHEN 3 THEN 'Consumption Area' 
    WHEN 4 THEN 'Supplier' 
    WHEN 5 THEN 'Consumption Area' 
    WHEN 6 THEN 'Consumption Area' 
    ELSE NULL END as 'classification'
FROM location 
LEFT OUTER JOIN location_classification ON location_classification.location_id = location.id 
WHERE location_classification.classification IS NULL;

