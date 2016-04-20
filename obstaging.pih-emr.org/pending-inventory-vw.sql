CREATE OR REPLACE VIEW pending_inventory_vw AS

  SELECT 'Mirebalais' as location_group, product_code, quantity FROM hum_pending_inventory_vw

  UNION ALL

  SELECT 'Port au Prince' as location_group, product_code, quantity FROM pap_pending_inventory_vw;

