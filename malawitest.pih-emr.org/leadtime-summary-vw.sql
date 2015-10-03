CREATE OR REPLACE VIEW leadtime_summary_vw AS
SELECT 
    product.product_code as product_code,
    project,
    lead_time_in_days
FROM leadtime
LEFT OUTER JOIN product ON product.product_code = leadtime.product_code;
