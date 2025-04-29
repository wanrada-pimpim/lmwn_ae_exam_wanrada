WITH ORDER_STATUS_DATETIME AS (
	SELECT
	    fleet.order_id,
	    fleet.driver_id,
	    fleet.region,
	    fleet.vehicle_type,
	    order_log.status AS order_status,
	    order_log.status_datetime AS created_datetime,
	    LEAD(order_log.status_datetime) OVER (PARTITION BY fleet.order_id, fleet.driver_id ORDER BY order_log.status_datetime) AS accepted_datetime
	FROM model_datamart.model_datamart_fleet_management_order AS fleet
	LEFT JOIN main.order_log_incentive_sessions_order_status_logs AS order_log
	ON fleet.order_id = order_log.order_id
	WHERE order_log.status IN ('created', 'accepted')
)
, TIME_GAP AS (
	SELECT
		order_id,
		driver_id,
		region,
	    vehicle_type,
		DATE_DIFF('minute', created_datetime, accepted_datetime) AS accepted_minute
	FROM ORDER_STATUS_DATETIME
	WHERE order_status = 'created'
)
SELECT
	region,
	vehicle_type,
	SUM(CASE WHEN accepted_minute IS NOT NULL THEN 1 ELSE 0 END) AS total_accepted_orders,
	COUNT(*) AS total_orders,
	ROUND(AVG(accepted_minute), 2) AS average_accepted_minute
FROM TIME_GAP
GROUP BY
	region,
	vehicle_type