{{ config ( 
    materialized = "table",
    schema = 'report_fleet_management' 
) }}

WITH AVAILABLE_DRIVERS AS (
	SELECT 
		driver_id,
		region,
		join_date,
		MAX(delivery_datetime) AS latest_delivery_datetime
	FROM {{ ref ('model_datamart_fleet_management_order') }}
	GROUP BY
		driver_id,
		region,
		join_date
)
, AVAILABLE_DRIVERS_YEAR_MONTH AS (
	SELECT
		driver_id,
		region,
		STRFTIME('%Y-%m', join_date) AS join_year_month,
		STRFTIME('%Y-%m', latest_delivery_datetime) AS latest_delivery_year_month,
	FROM AVAILABLE_DRIVERS
)
, DELIVERY_ZONE_ORDERS AS (
	SELECT
		delivery_zone,
		STRFTIME('%Y-%m', order_datetime) AS order_year_month,
		COUNT(*) AS count_orders
	FROM {{ ref ('model_datamart_fleet_management_order') }}
	GROUP BY 
		delivery_zone,
		STRFTIME('%Y-%m', order_datetime)
)
SELECT
    orders.delivery_zone,
    orders.order_year_month,
    orders.count_orders,
    SUM(CASE WHEN orders.order_year_month BETWEEN drivers.join_year_month AND drivers.latest_delivery_year_month THEN 1 ELSE 0 END) AS count_available_drivers,
    ROUND(orders.count_orders / SUM(CASE WHEN orders.order_year_month BETWEEN drivers.join_year_month AND drivers.latest_delivery_year_month THEN 1 ELSE 0 END), 0) AS demand_orders_per_driver_per_month    
FROM DELIVERY_ZONE_ORDERS AS orders
LEFT JOIN AVAILABLE_DRIVERS_YEAR_MONTH AS drivers
ON orders.delivery_zone = drivers.region
GROUP BY
	orders.delivery_zone,
    orders.order_year_month,
    orders.count_orders