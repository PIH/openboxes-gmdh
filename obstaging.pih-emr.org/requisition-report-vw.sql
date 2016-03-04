CREATE OR REPLACE VIEW requisition_report_vw AS
select
  product.product_code,
  product.name,
  day(requisition.date_requested) as day,
  month(requisition.date_requested) as month,
  year(requisition.date_requested) as year,
  IFNULL(product_group_category.name, category.name) as category,
  count(parent.id) as count,
  sum(parent.quantity) as total_requested,
  sum(parent.quantity_canceled) as total_canceled,
  sum(child.quantity) as total_issued,
  (sum(parent.quantity_canceled) - IFNULL(sum(child.quantity), 0)) as total_missed,
  group_concat(distinct parent.cancel_reason_code)
from requisition_item parent
join requisition on parent.requisition_id = requisition.id
join location destination on requisition.destination_id = destination.id
join location origin on requisition.origin_id = origin.id
join product on product.id = parent.product_id
join category on product.category_id = category.id 
left outer join requisition_item child on parent.id = child.parent_requisition_item_id
LEFT JOIN product_group_product ON product_group_product.product_id = product.id
LEFT JOIN product_group ON product_group.id = product_group_product.product_group_id
LEFT JOIN category product_group_category ON product_group_category.id = product_group.category_id
where parent.quantity_canceled > 0
and destination.name = 'HUM Depot 1 (Picking)'
and requisition.status IN ('ISSUED')
and year(requisition.date_requested) >= 2015
and parent.cancel_reason_code IN ('STOCKOUT', 'INSUFFICIENT_QUANTITY_RECONDITIONED', 'LOW_STOCK')
group by product.product_code, month(requisition.date_requested), year(requisition.date_requested);