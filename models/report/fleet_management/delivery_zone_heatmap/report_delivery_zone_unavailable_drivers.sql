SELECT
    fleet.delivery_zone,
    SUM(CASE WHEN order_log.status = 'failed' THEN 1 ELSE 0 END) AS count_failed_orders,
    SUM(CASE WHEN order_log.status = 'canceled' THEN 1 ELSE 0 END) AS count_canceled_orders,
FROM model_datamart.model_datamart_fleet_management_order AS fleet
LEFT JOIN main.order_log_incentive_sessions_order_status_logs AS order_log
ON fleet.order_id = order_log.order_id