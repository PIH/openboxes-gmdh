DROP TABLE IF EXISTS leadtime;
/* Create the new leadtime table */
CREATE TABLE IF NOT EXISTS leadtime 
(
    project VARCHAR(255),
    product_code VARCHAR(10),
    product_description VARCHAR(255),
    lead_time_in_days DECIMAL(10,2)
);

