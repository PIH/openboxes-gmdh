DROP FUNCTION GetTagsByProductGroup;
DELIMITER //
CREATE FUNCTION GetTagsByProductGroup(p_productGroupId CHAR(38)) RETURNS VARCHAR(2000)
    DETERMINISTIC
BEGIN
    DECLARE tags varchar(2000);
    SET tags = (
        SELECT group_concat(DISTINCT tag.tag separator '|')
        FROM product 
        LEFT JOIN product_tag ON product_tag.product_id = product.id 
        LEFT JOIN tag ON product_tag.tag_id = tag.id 
        LEFT JOIN product_group_product ON product_group_product.product_id = product.id
        LEFT JOIN product_group ON product_group_product.product_group_id = product_group.id        
        WHERE product.product_code = p_productCode   
    );
    RETURN (tags);    
END//
DELIMITER ;
