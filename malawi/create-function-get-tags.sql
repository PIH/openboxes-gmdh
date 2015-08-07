DROP FUNCTION IF EXISTS GetTags;
DELIMITER //
CREATE FUNCTION GetTags(p_productCode CHAR(38)) RETURNS VARCHAR(2000)
    DETERMINISTIC
BEGIN
    DECLARE tags varchar(2000);
    SET tags = (
        SELECT group_concat(DISTINCT tag.tag separator '|')
        FROM product 
        LEFT JOIN product_tag ON product_tag.product_id = product.id 
        LEFT JOIN tag ON product_tag.tag_id = tag.id 
        WHERE product.product_code = p_productCode   
    );
    RETURN (tags);    
END//
DELIMITER ;
 
/*
SELECT product_code, GetTags(product_code) from product limit 5; 
 
select group_concat(distinct tag.tag separator '|'), product.id, product.name
from product 
left join product_tag on product_tag.product_id = product.id 
left join tag on product_tag.tag_id = tag.id 
left join inventory_level on inventory_level.product_id = product.id 
left join inventory on inventory.id = inventory_level.inventory_id
left join location on inventory.id = location.inventory_id
where location.name = 'HUM Depot 1 (Picking)' 
AND product.product_code = p_productCode
group by product.id;


SELECT product_group.id, group_concat(DISTINCT tag.tag separator '|')
FROM product 
LEFT JOIN product_tag ON product_tag.product_id = product.id 
LEFT JOIN tag ON product_tag.tag_id = tag.id 
LEFT JOIN product_group_product ON product_group_product.product_id = product.id
LEFT JOIN product_group ON product_group_product.product_group_id = product_group.id        
GROUP BY product_group.id
LIMIT 10;
*/
