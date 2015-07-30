SELECT
  CONCAT(IFNULL(pgc.name, category.name), '::', product.product_code) AS cat_code,
  1,
  CONCAT(IFNULL(pgc.name, category.name), '::', (
     SELECT
       GROUP_CONCAT(
         DISTINCT product_code
         ORDER BY product_code)
     FROM product
     INNER JOIN product_group_product
       ON product_group_product.product_id = product.id
     INNER JOIN product_group AS b
       ON product_group_product.product_group_id = b.id
     WHERE a.id = b.id
     GROUP BY b.id
  )) AS codelist,
  a.description
FROM product
INNER JOIN category
  ON product.category_id = category.id
INNER JOIN product_group_product AS pgp
  ON pgp.product_id = product.id
INNER JOIN product_group AS a
  ON pgp.product_group_id = a.id
INNER JOIN product_group_product AS pgp2
  ON pgp.product_group_id = pgp2.product_group_id
LEFT OUTER JOIN category pgc
  ON pgc.id = a.category_id
GROUP BY product.id
HAVING COUNT(pgp2.product_id) > 1;