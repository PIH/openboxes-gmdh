CREATE OR REPLACE VIEW pending_orders_vw AS

  SELECT 'Mirebalais', product_code, quantity FROM hum_pending_orders_vw

  UNION ALL

  SELECT 'Port au Prince', product_code, quantity FROM pap_pending_orders_vw

  UNION ALL

  SELECT 'Sierra Leone', product_code, quantity FROM sl_pending_orders_vw
