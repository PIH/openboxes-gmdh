/* drop all tables */
drop table if exists location_classification;
drop table if exists dim_product_location;
drop table if exists leadtime;
drop table if exists leadtime_summary_mv;

/* drop all views */
drop view if exists consumption_report_vw;
drop view if exists gmdh_inventory_vw;
drop view if exists gmdh_miami_inventory_vw;
drop view if exists gmdh_pending_orders_vw;
drop view if exists hum_inventory_query_debug_vw;
drop view if exists hum_inventory_query_vw;
drop view if exists hum_pending_orders_vw;
drop view if exists latest_inventory_snapshot;
drop view if exists leadtime_summary_vw;
drop view if exists leadtime_summary_vw_old;
drop view if exists miami_inventory_snapshot_vw;
drop view if exists pap_inventory_query_debug_vw;
drop view if exists pap_inventory_query_vw;
drop view if exists pap_pending_orders_intermediate_vw;
drop view if exists pap_pending_orders_plus_miami_inventory_snapshot_vw;
drop view if exists pap_pending_orders_vw;
drop view if exists pending_orders_vw;
drop view if exists pap_pending_inventory_vw;
drop view if exists hum_pending_inventory_vw;
drop view if exists pending_inventory_vw;
drop view if exists reorder_point_vw;
drop view if exists shipment_status;
drop view if exists sl_pending_orders_vw;
drop view if exists transaction_report_vw;
drop view if exists requisition_report_vw;

/* Weird issue where after dropping a view, a table with the same name remains. */
drop table if exists consumption_report_vw;
drop table if exists gmdh_inventory_vw;
drop table if exists gmdh_miami_inventory_vw;
drop table if exists gmdh_pending_orders_vw;
drop table if exists hum_inventory_query_debug_vw;
drop table if exists hum_inventory_query_vw;
drop table if exists hum_pending_orders_vw;
drop table if exists latest_inventory_snapshot;
drop table if exists leadtime_summary_vw;
drop table if exists leadtime_summary_vw_old;
drop table if exists miami_inventory_snapshot_vw;
drop table if exists pap_inventory_query_debug_vw;
drop table if exists pap_inventory_query_vw;
drop table if exists pap_pending_orders_intermediate_vw;
drop table if exists pap_pending_orders_plus_miami_inventory_snapshot_vw;
drop table if exists pap_pending_orders_vw;
drop table if exists pending_orders_vw;
drop table if exists pap_pending_inventory_vw;
drop table if exists hum_pending_inventory_vw;
drop table if exists pending_inventory_vw;
drop table if exists reorder_point_vw;
drop table if exists shipment_status;
drop table if exists sl_pending_orders_vw;
drop table if exists transaction_report_vw;
drop table if exists requisition_report_vw;

#alter table inventory_snapshot drop index inventory_snapshot_key;
#alter table inventory_item_snapshot drop index inventory_item_snapshot_key;



