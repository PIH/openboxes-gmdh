SELECT stamp, sum(SumOfQuantity) as SumOfQuantity, cat_code
FROM (
	(
	  SELECT
      MAKEDATE(tvw.year, 1) + INTERVAL (tvw.month - 1) MONTH AS stamp,
      SUM(tvw.quantity) AS SumOfquantity,
      CONCAT(tvw.category, '::', tvw.product_code) AS cat_code,
      'Issued'
    FROM transaction_report_vw AS tvw
    WHERE tvw.source_hub = 'Mirebalais'
      AND tvw.source_class IN ('Level 1', 'Level 2')
      AND tvw.destination_hub IN ('Mirebalais')
      AND tvw.destination_class = 'Consumption Area'
    GROUP BY tvw.year, tvw.month, tvw.product_code, tvw.category
  )

	UNION ALL

	(
	  SELECT
      MAKEDATE(rvw.year, 1) + INTERVAL (rvw.month - 1) MONTH AS stamp,
      SUM(rvw.total_missed) AS SumOfquantity,
      CONCAT(rvw.category, '::', rvw.product_code) AS cat_code,
      'Missed'
    FROM requisition_report_vw AS rvw
    GROUP BY rvw.year, rvw.month, rvw.product_code, rvw.category
  )
) as main_query 
GROUP BY stamp, cat_code
ORDER BY stamp