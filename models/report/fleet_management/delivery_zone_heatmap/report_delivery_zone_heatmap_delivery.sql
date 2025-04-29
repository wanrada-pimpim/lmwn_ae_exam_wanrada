SELECT
    delivery_zone,
    SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) AS count_completed_orders,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS count_canceled_orders,
    SUM(CASE WHEN order_status = 'failed' THEN 1 ELSE 0 END) AS count_failed_orders,
    COUNT(*) AS count_total_orders,
    ROUND(SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percent_completed_orders,
    ROUND(AVG(CASE WHEN order_status = 'completed' THEN delivery_minute ELSE NULL END), 2) AS average_completed_order_delivery_minute
FROM model_datamart.model_datamart_fleet_management_order
WHERE delivery_zone IS NOT NULL
GROUP BY delivery_zone