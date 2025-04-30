{{ config ( 
    materialized = "table",
    schema = 'report_fleet_management' 
) }}

SELECT
    delivery_zone,
    delivery_minute,
    COUNT(*) AS count_late_delivery_orders
FROM {{ ref ('model_datamart_fleet_management_order') }}
WHERE is_late_delivery IS TRUE
GROUP BY
    delivery_zone,
    delivery_minute