{{ config ( 
    materialized = "table",
    schema = 'model_datamart' 
) }}

SELECT
    drivers_master.driver_id,
    drivers_master.region,
    drivers_master.vehicle_type,
    drivers_master.driver_rating,
    drivers_master.join_date,
    drivers_master.active_status AS driver_status,
    order_transactions.order_id,
    order_transactions.order_status,
    order_transactions.delivery_zone,
    order_transactions.order_datetime,
    order_transactions.pickup_datetime,
    order_transactions.delivery_datetime,
    date_diff('minute', order_transactions.pickup_datetime, order_transactions.delivery_datetime) AS delivery_minute,
    order_transactions.is_late_delivery
FROM {{ source ('source_masters', 'drivers_master') }}
LEFT JOIN {{ source ('source_transactions', 'order_transactions') }}
ON drivers_master.driver_id = order_transactions.driver_id