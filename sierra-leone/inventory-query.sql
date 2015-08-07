SELECT
  CONCAT(IFNULL(product_group_category.name, category.name), '::', product.product_code) AS cat_code,
  product.name,
  GREATEST(SUM(snap.quantity_on_hand), 0) AS qty,
  leadtime_summary_vw.lead_time_in_days,
  NULL, NULL, NULL, NULL,
  GetTags(product.product_code)
FROM product
  INNER JOIN category ON product.category_id = category.id
  LEFT JOIN inventory_snapshot AS snap
    ON snap.product_id = product.ID
  INNER JOIN location ON snap.location_id = location.id
  INNER JOIN location_group
    ON (location_group.id = location.location_group_id
      AND location_group.name = 'Sierra Leone')
  INNER JOIN location_type
    ON (location_type.id = location.location_type_id
      AND location_type.name LIKE 'Depot%')
  INNER JOIN (
     SELECT product_id, location_id, MAX(date) AS maxdate
     FROM inventory_snapshot
     GROUP BY product_id, location_id
  ) AS is2 ON snap.location_id = is2.location_id AND snap.product_id = is2.product_id AND snap.date = maxdate
  LEFT OUTER JOIN leadtime_summary_vw ON (product.product_code = leadtime_summary_vw.product_code AND leadtime_summary_vw.project = 'Sierra Leone Project')
  LEFT OUTER JOIN reorder_point_vw ON (product.id = reorder_point_vw.product_id AND reorder_point_vw.location_group = 'Sierra Leone')
  LEFT OUTER JOIN product_group_product ON product_group_product.product_id = product.id
  LEFT OUTER JOIN product_group ON product_group.id = product_group_product.product_group_id
  LEFT OUTER JOIN category product_group_category ON product_group_category.id = product_group.category_id
  LEFT OUTER JOIN pending_orders_vw ON product.product_code = pending_orders_vw.product_code and pending_orders_vw.location_group = 'Sierra Leone'
GROUP BY snap.product_id;