SELECT 
	driver_id,
	driver_rating,
	SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) AS count_completed_orders,
	COUNT(*) AS count_assigned_orders
FROM model_datamart.model_datamart_fleet_management_order
GROUP BY
	driver_id,
	driver_rating