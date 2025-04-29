SELECT
    region,
    vehicle_type,
    SUM(delivery_minute) AS total_delivery_minute,
    COUNT(order_id) AS count_delivery,
    ROUND(AVG(delivery_minute), 2) AS average_delivery_minute,
    SUM(CASE WHEN is_late_delivery IS TRUE THEN 1 ELSE 0 END) AS count_late_delivery_orders
FROM model_datamart.model_datamart_fleet_management_order
WHERE order_status = 'completed'
GROUP BY 
    region,
	vehicle_type