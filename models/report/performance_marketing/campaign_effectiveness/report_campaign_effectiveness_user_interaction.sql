{{ config ( 
    materialized = "table",
    schema = 'report_performance_marketing' 
) }}

SELECT
    campaign_name,
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS count_impression,
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS count_click,
    SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) AS count_conversion,
    COUNT(DISTINCT CASE WHEN order_status = 'completed' THEN customer_id ELSE NULL END) AS count_user_purchase_after_interaction,
    SUM(ad_cost) AS total_ad_cost,
    SUM(total_amount) AS total_revenue
FROM {{ ref ('model_datamart_performance_marketing') }}
WHERE campaign_id IS NOT NULL
GROUP BY campaign_name