SELECT
  MAKEDATE(year, 1) + INTERVAL (vw.month - 1) MONTH AS stamp, 
  SUM(quantity) AS SumOfquantity, 
  CONCAT(category, '::', product_code) AS cat_code	
FROM transaction_report_vw AS vw
WHERE source_hub = 'Lisungwi'
  AND source_class IN ('Level 1', 'Level 2')
  AND destination_hub IN ('Lisungwi', NULL)
  AND destination_class = 'Consumption Area'
GROUP BY year, month, product_code, category
ORDER BY stamp
