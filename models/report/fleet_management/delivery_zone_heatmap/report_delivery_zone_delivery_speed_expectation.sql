SELECT
    delivery_zone,
    delivery_minute,
    COUNT(*) AS count_late_delivery_orders
FROM model_datamart.model_datamart_fleet_management_order
WHERE is_late_delivery IS TRUE
GROUP BY
    delivery_zone,
    delivery_minute