select 
	product.id, 
    product.product_code, 
    product.name, 
    product.date_created,
    concat(person.first_name, ' ', person.last_name) as creator
from product 
left join user on user.id = product.created_by_id
join person on user.id = person.id
where product.date_created >= (now() - interval 7 day)\G
