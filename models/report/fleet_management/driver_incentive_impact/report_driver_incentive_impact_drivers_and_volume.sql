{{ config ( 
    materialized = "table",
    schema = 'report_fleet_management' 
) }}

SELECT
    incentive_program,
    COUNT(DISTINCT driver_id) AS count_drivers,
    SUM(actual_deliveries) AS count_orders
FROM {{ ref ('model_datamart_fleet_management_incentive_program') }}
WHERE incentive_program IS NOT NULL
GROUP BY incentive_program