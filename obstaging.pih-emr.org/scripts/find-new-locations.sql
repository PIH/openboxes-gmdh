select 
    location.id, 
    location.name, 
    location_type.name, 
    location_group.name as location_group, 
    location_classification.classification as classification, 
    location.date_created
from location 
left join location_group on location.location_group_id = location_group.id
left join location_classification on location.id = location_classification.location_id
join location_type on location_type.id = location.location_type_id
where location.date_created >= (now() - interval 7 day)\G
