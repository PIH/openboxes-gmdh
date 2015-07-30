CREATE OR REPLACE VIEW shipment_status AS 
SELECT 
    shipment.id as shipment_id,
    shipment.shipment_number, 
    substr(origin.name, 1, 50) as origin, 
    substr(origin_type.name,1,locate('|',origin_type.name)-1) as origin_type,
    substr(destination.name, 1, 50) as destination, 
    substr(destination_type.name,1,locate('|',destination_type.name)-1) as destination_type,
    GROUP_CONCAT(substr(event_type.name,1,locate('|',event_type.name)-1) SEPARATOR ',') as status,
    max(event.event_date)
FROM shipment 
JOIN location origin ON origin.id = shipment.origin_id
JOIN location_type origin_type ON origin.location_type_id = origin_type.id
JOIN location destination ON destination.id = shipment.destination_id
JOIN location_type destination_type ON destination.location_type_id = destination_type.id
LEFT OUTER JOIN shipment_event ON shipment.id = shipment_event.shipment_events_id
LEFT OUTER JOIN event ON event.id = shipment_event.event_id
LEFT OUTER JOIN event_type event_type ON event_type.id = event.event_type_id
GROUP BY shipment.id
;
